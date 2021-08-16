package vehicle

import (
	"delivery/coords"
	"fmt"
)

const (
	// CarType the vehicle is a car
	CarType VehicleType = VehicleType(0)

	// BicycleType the vehicle is a bicycle
	BicycleType VehicleType = VehicleType(1)
)

type (
	// Vehicle containing id, name, capacity and current position
	Vehicle struct {
		ID       int                `json:"id"`
		Name     string             `json:"name"`
		Capacity int               	`json:"capacity"`
		Pos      coords.Coordinates `json:"position"`
		Type	 VehicleType		`json:"vehicle_type"`
	}

	// VehicleType is the type of vehicle
	VehicleType uint8
)

// New create and initializes a new vehicle
func New(id int, name string, cap int, pos coords.Coordinates) *Vehicle {
	return &Vehicle{ID: id, Name: name, Capacity: cap, Pos: pos, Type: CarType}
}

// String a string representation of a vehicle
func (v Vehicle)String() string {
	return fmt.Sprintf("[ %d | %s | %d | %.6f | %.6f ]", v.ID, v.Name, v.Capacity, v.Pos.Lat, v.Pos.Lng)
}
