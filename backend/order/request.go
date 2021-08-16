package order

import (
	"delivery/restaurant"
)

// Request models the incoming POST request
// from the customer wanting to place an order
type Request struct {
	CustomerID 	int 			`json:"customer_id"`
	Food 		restaurant.Food `json:"food"`
}
