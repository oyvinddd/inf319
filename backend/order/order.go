package order

import (
	"delivery/customer"
	"delivery/restaurant"
	"delivery/timewindow"
	"time"
)

const (
	// Unhandled orders have not been picked up yet
	Unhandled Status = Status(0)

	// InTransit orders are currently being delivered
	InTransit Status = Status(1)

	// Completed orders have been delivered to the end user
	Completed Status = Status(2)

	// MaxDeliveryTime is the maximum amount of time we can use to deliver an order
	MaxDeliveryTime = time.Minute * time.Duration(30)
)

type (
	// Order struct
	Order struct {
		ID 			int 					`json:"id"`
		Status 		Status 					`json:"status"`
		Food 		restaurant.Food 		`json:"food"`
		Origin 		restaurant.Restaurant	`json:"origin"`
		Destination customer.Customer 		`json:"destination"`
		Window 		timewindow.TimeWindow 	`json:"time_window"`
	}

	// Status of an order can be one of three; unhandled, in transit or complete
	Status uint8
)

// New creates and initializes a new order
func New(id int, food restaurant.Food, orig restaurant.Restaurant, dest customer.Customer) *Order {
	// lower time bound for delivery is the current time + the time it takes to prepare the food
	lower := time.Now().Add(time.Minute * time.Duration(food.PreparationTime)).UTC()
	// upper time bound is the lower time + a maximum of 30 minutes for transportation
	upper := lower.Add(MaxDeliveryTime)
	window := timewindow.TimeWindow{Lower: lower, Upper: upper}
	return &Order{
		ID: id,
		Status: Unhandled,
		Food: food,
		Origin: orig,
		Destination: dest,
		Window: window,
	}
}
