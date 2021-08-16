package handler

import (
	"delivery/data"
	"delivery/order"
	"delivery/route"
	"encoding/json"
	"errors"
	"io"
	"net/http"
)

var (
	errInvalidOrderRequestFormat = errors.New("invalid order request format")
)

// OrderHandler is responsible for handling creation and fetching of orders through HTTP
type OrderHandler struct {
	routeService route.Service
	data *data.Container
}

// NewOrderHandler creates and initializes a new order handler
func NewOrderHandler(routeService route.Service, data *data.Container) OrderHandler {
	return OrderHandler{routeService: routeService, data: data}
}

// CreateOrder handles create order request
func (h OrderHandler)CreateOrder(w http.ResponseWriter, r *http.Request) {
	order, err := h.decodeAndValidateOrder(r.Body)
	if err != nil {
		respondWithError(w, http.StatusBadRequest, err.Error())
		return
	}
	// get the starting/ending coordinates for the order
	orig := order.Origin.Pos
	dest := order.Destination.Pos
	// give the coordinates to our route service so that a path can be calculate
	path, err := h.routeService.CalculatePathFromCoords(orig, dest, route.DrivingMode)
	if err != nil {
		respondWithError(w, http.StatusInternalServerError, err.Error())
		return
	}
	// pick a vehicle to do the job
	vehicle := *h.data.Vehicles[0] // TODO: we should pick the vehicle that is closest to the restaurant
	// add newly created route to our data and respond to user with success
	if err := h.data.AddRoute(route.New(path, vehicle, order)); err != nil {
		respondWithError(w, http.StatusBadRequest, err.Error())
		return
	}
	respondWithJSON(w, http.StatusOK, order)
}

func (h OrderHandler)GetOrders(w http.ResponseWriter, r *http.Request) {
	orders, _ := h.data.FindOrders(1) // TODO: fix hardcoded customer ID
	respondWithJSON(w, http.StatusOK, orders)
}

// DeleteOrders handles delete order request
func (h OrderHandler)DeleteOrders(w http.ResponseWriter, r *http.Request) {
	// any active order is a sub element of a route, so we are in fact deleting routes (containing orders)
	h.data.DeleteAllRoutes()
	respondWithStatus(w, http.StatusOK)
}

func (h OrderHandler)decodeAndValidateOrder(body io.ReadCloser) (*order.Order, error) {
	// incoming data is actually an order request, so first decode this
	var req order.Request
	if err := json.NewDecoder(body).Decode(&req); err != nil {
		return nil, errInvalidOrderRequestFormat
	}
	// find customer with the given id in our system
	customer, err := h.data.FindCustomer(req.CustomerID)
	if err != nil {
		return nil, err
	}
	// find the restaurant with the given id in our system
	restaurant, err := h.data.FindRestaurant(req.Food.RestaurantID)
	if err != nil {
		return nil, err
	}
	return order.New(0, req.Food, *restaurant, *customer), nil
}
