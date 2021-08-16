package restaurant

import (
	"delivery/coords"
	"fmt"
)

// Restaurant struct
type Restaurant struct {
	ID   int                `json:"id"`
	Name string             `json:"name"`
	Menu []Food             `json:"menu"`
	Pos  coords.Coordinates `json:"position"`
}

// New creates an initializes a new restaurant
func New(id int, name string, pos coords.Coordinates) *Restaurant {
	return &Restaurant{
		ID: id,
		Name: name,
		Menu: make([]Food, 0),
		Pos: pos,
	}
}

// AddFood adds a new food to the given restaurant
func (r Restaurant)AddFood(food Food) {
	r.Menu = append(r.Menu, food)
}

// PrintMenu prints the contents of the menu to standard output
func (r Restaurant)PrintMenu() {
	fmt.Println("### MENU START ###")
	for _, food := range r.Menu {
		fmt.Println(food)
	}
	fmt.Println("### MENU END ###")
}

// String returns a string representation of a restaurant
func (r Restaurant)String() string {
	return fmt.Sprintf("%d|%s|%.6f|%.6f", r.ID, r.Name, r.Pos.Lat, r.Pos.Lng)
}
