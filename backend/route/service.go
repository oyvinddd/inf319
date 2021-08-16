package route

import (
	"delivery/coords"
)

const (
	// DrivingMode the vehicle is a car
	DrivingMode TravelMode = TravelMode("driving")

	// BicycleMode the vehicle is a bicycle
	BicycleMode TravelMode = TravelMode("bicycling")
)

type (
	// Service interface for calculating route from A to B
	Service interface {
		CalculatePathFromCoords(coords.Coordinates, coords.Coordinates, TravelMode) ([]PathSegment, error)
		CalculatePathFromAddr(string, string, TravelMode) ([]PathSegment, error)
	}

	// TravelMode is the mode of transportation for the vehicle
	TravelMode string
)
