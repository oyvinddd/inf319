package data

import (
	"delivery/customer"
	"delivery/order"
	"delivery/restaurant"
	"delivery/route"
	"delivery/vehicle"
	"errors"
	"sync"
	"time"
)

var (
	// NoOfActiveRoutes the number of active routes at any given time in the system
	NoOfActiveRoutes = 0

	// NoOfSpecialOffers the number of special orders currently available in the system
	NoOfSpecialOffers = 0
)

var (
	errCustomerNotFound = errors.New("customer not found")
	errRestaurantNotFound = errors.New("restaurant not found")
	errRouteAlreadyExists = errors.New("route already exists")
)

type (
	// Container wraps all the data
	Container struct {
		Restaurants	[]*restaurant.Restaurant
		Vehicles	[]*vehicle.Vehicle
		Customers	[]*customer.Customer
		Routes		[]*route.Route
		observers	sync.Map
	}
)

// New creates and initializes a new data container
func New(restaurants []*restaurant.Restaurant, vehicles []*vehicle.Vehicle, customers []*customer.Customer) Container {
	return Container{
		Restaurants: restaurants,
		Vehicles: vehicles,
		Customers: customers,
		Routes: make([]*route.Route, 0),
		observers: sync.Map{},
	}
}

// AddRoute adds a new route to the list
func (c *Container)AddRoute(route *route.Route) error {
	if c.RouteExists(route) {
		return errRouteAlreadyExists
	}
	route.ID = NoOfActiveRoutes
	NoOfActiveRoutes++
	route.Offers = c.GenerateOffersForRoute(route)
	c.Routes = append(c.Routes, route)
	c.Notify(NewEvent(RouteCreatedEvent, route))
	return nil
}

// DeleteAllRoutes deletes all active routes
func (c *Container)DeleteAllRoutes() {
	c.Routes = make([]*route.Route, 0)
	c.Notify(NewEvent(RoutesDeletedEvent, nil))
	NoOfActiveRoutes = 0
}

// FindCustomer searches the list of customers for a customer with the given id
func (c Container)FindCustomer(customerID int) (*customer.Customer, error) {
	// do a simple linear search for a customer with the given id
	for _, customer := range c.Customers {
		if customer.ID == customerID {
			return customer, nil
		}
	}
	return nil, errCustomerNotFound
}

// FindRestaurant searches the list of restaurants for a restaurant with the given id
func (c Container)FindRestaurant(restaurantID int) (*restaurant.Restaurant, error) {
	// do a simple linear search for a restaurant with the given id
	for _, restaurant := range c.Restaurants {
		if restaurant.ID == restaurantID {
			return restaurant, nil
		}
	}
	return nil, errRestaurantNotFound
}

// FindOrders searches the list of active routes for an order with a given customer ID
func (c Container)FindOrders(customerID int) ([]*order.Order, error) {
	var orders = make([]*order.Order, 0)
	for _, route := range c.Routes {
		for _, order := range route.Orders {
			// TODO: add condition here to check if the customer ID of the order matches the incoming customer ID
			orders = append(orders, order)
		}
	}
	return orders, nil
}

// RouteExists checks if the incoming route already exists based on the origin and destination
func (c Container)RouteExists(route *route.Route) bool {
	if route == nil {
		return false
	}
	for _, r := range c.Routes {
		if r.IsEqual(route) {
			return true
		}
	}
	return false
}

// GenerateOffersForRoute generates special offers using the restaurants and users close to the route
func (c Container)GenerateOffersForRoute(route *route.Route) []*restaurant.SpecialOffer {
	// first we get all the restaurants and customers that are within the bounds of the route
	restaurants, customers := c.restaurantsAndCustomersWithinBounds(route)
	// then we check which of the restaurant-customer pairs that are feasible based on time constraints
	specialOffers := calculateSpecialOffers(route, restaurants, customers)
	return specialOffers
}

// AddListener adds a new observer to the map
func (c *Container)AddListener(obs Observer) {
	c.observers.Store(obs, struct{}{})
}

// RemoveListener removes a given observer from the map
func (c *Container)RemoveListener(obs Observer) {
	c.observers.Delete(obs)
}

// Notify notifies all observers of an incoming event
func (c *Container)Notify(event Event) {
	c.observers.Range(func(key interface{}, value interface{}) bool {
		if key == nil || value == nil {
			return false
		}
		key.(Observer).NotifyCallback(event)
		return true
	})
}

// finds feasible pairs of restaurants and customers applicable for special offer based on the original route
func (c Container)restaurantsAndCustomersWithinBounds(route *route.Route) ([]*restaurant.Restaurant, []*customer.Customer) {
	restaurants, customers := make([]*restaurant.Restaurant, 0), make([]*customer.Customer, 0)
	// keep track of restaurants/customers already added to the lists (we don't want to add duplicates)
	addedRestaurants := make(map[int]bool, len(c.Restaurants))
	addedCustomers := make(map[int]bool, len(c.Customers))
	// iterate through each segment in the path and check for nearby restaurants and customers
	for _, segment := range route.Path {
		boundingBox := segment.Box
		// restaurants
		for _, restaurant := range c.Restaurants {
			_, exists := addedRestaurants[restaurant.ID]
			if !exists && (segment.BoundingCircleContainsCoords(restaurant.Pos) || boundingBox.Contains(restaurant.Pos)) {
				restaurants = append(restaurants, restaurant)
				addedRestaurants[restaurant.ID] = true
			}
		}
		// customers
		for _, customer := range c.Customers {
			_, exists := addedCustomers[customer.ID]
			if !exists && (segment.BoundingCircleContainsCoords(customer.Pos) || boundingBox.Contains(customer.Pos)) {
				customers = append(customers, customer)
				addedCustomers[customer.ID] = true
			}
		}
	}
	return restaurants, customers
}

func calculateSpecialOffers(route *route.Route, restaurants []*restaurant.Restaurant, customers []*customer.Customer) []*restaurant.SpecialOffer {
	specialOffers := make([]*restaurant.SpecialOffer, 0)
	originalOrder := route.Orders[0]
	// for each pair of restaurants and customer we check if it is a feasible pair in terms of time constraints
	for _, rest := range restaurants {
		for _, cust := range customers {

			restaurantSegment, restaurantDistance := route.ClosestSegment(rest.Pos)
			customerSegment, customerDistance := route.ClosestSegment(cust.Pos)

			// first we calculate the duration to travel from the nearest point on the route to
			// the restaurant and the nearest point on the route to the customer
			restaurantDetourDuration := int(restaurantDistance) / route.AvgSpeed * 2
			customerDetourDuration := int(customerDistance) / route.AvgSpeed * 2

			totalDetourDuration := time.Duration(route.Duration + restaurantDetourDuration + customerDetourDuration)
			// this condition holds when a customer is located before a restaurant on the route
			if restaurantSegment.Number > customerSegment.Number {
				// reverse duration is the time it takes for the vehicle to turn around and fulfill
				// the intermediate order where the customer is located before the restaurant on the route
				reverseDuration := route.DurationBetweenSegments(customerSegment.Number, restaurantSegment.Number) * 2
				totalDetourDuration += time.Duration(reverseDuration)
			}
			// calculate estimated arrival time at the original customer
			estimatedArrivalTime := originalOrder.Window.Lower.Add(time.Second * totalDetourDuration).UTC()
			// if we arrive at the destination before the order expires, we can create a special order
			// from the given restaurant-customer pair
			if originalOrder.Window.Upper.After(estimatedArrivalTime) {
				food := rest.Menu[0] // TODO: this should not be hard coded like this
				offer := restaurant.NewSpecialOffer(NoOfSpecialOffers, food, cust.ID)
				specialOffers = append(specialOffers, offer)
				NoOfSpecialOffers++
				//fmt.Printf("(%d | %d) Feasible pair (%d, %d): Estimated arrival time: %v vs. order expiration time: %v\n", restaurantSegment.Number, customerSegment.Number, food.RestaurantID, cust.ID, estimatedArrivalTime, originalOrder.Window.Upper)
			}
		}
	}
	return specialOffers
}
