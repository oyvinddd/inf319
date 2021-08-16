package customer

import (
	"delivery/coords"
	"fmt"
)

// Customer struct
type Customer struct {
	ID   int                `json:"id"`
	Name string             `json:"name"`
	Pos  coords.Coordinates `json:"position"`
}

// New creates and initializes a new customer
func New(id int, name string, pos coords.Coordinates) *Customer {
	return &Customer{
		ID: id,
		Name: name,
		Pos: pos,
	}
}

// String returns a string representation of a customer
func (c Customer)String() string {
	return fmt.Sprintf("%d|%s|%.6f|%.6f", c.ID, c.Name, c.Pos.Lat, c.Pos.Lng)
}
