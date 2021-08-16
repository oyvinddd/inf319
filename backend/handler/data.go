package handler

import (
	"delivery/data"
	"net/http"
)

// DataHandler is responsible for serving data to clients through HTTP
type DataHandler struct {
	data *data.Container
}

// NewDataHandler creates and initializes a new data handler
func NewDataHandler(data *data.Container) DataHandler {
	return DataHandler{data: data}
}

// ListData responds to the caller with lists of all restaurants and customers in the system
func (h DataHandler)ListData(w http.ResponseWriter, r *http.Request) {
	dataMap := map[string]interface{}{
		"restaurants": h.data.Restaurants,
		"customers": h.data.Customers,
	}
	respondWithJSON(w, http.StatusOK, dataMap)
}

// ListRestaurants responds to the caller with a list of all restaurants in the system
func (h DataHandler)ListRestaurants(w http.ResponseWriter, r *http.Request) {
	respondWithJSON(w, http.StatusOK, h.data.Restaurants)
}
