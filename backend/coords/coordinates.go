package coords

import (
	"fmt"
	"math"
)

const (
	radEarth float64 = 6372.8 * 1000 // meters
)

type Coordinates struct {
	Lat float64 `json:"lat"`
	Lng float64 `json:"lng"`
}

func New(lat float64, lng float64) *Coordinates {
	return &Coordinates{
		Lat: lat,
		Lng: lng,
	}
}

// Distance calculates the Euclidean distance between two points
func (c Coordinates)Distance(c2 Coordinates) float64 {
	// This is function calculates the basic Euclidean distance between two coordinates.
	// The Haversine formula will need to be used for coordinates that are longer a part
	// (https://en.wikipedia.org/wiki/Haversine_formula), but for our use case we don't need it.
	return math.Sqrt(math.Pow(c2.Lat - c.Lat, 2) + math.Pow(c2.Lng - c.Lng, 2))
}

// HaversineDistance calculates the Haversine distance (in meters) between two coordinate points.
// One needs to use the Haversine formulae when calculating distances on a sphere.
// For more info read here: https://en.wikipedia.org/wiki/Haversine_formula
func (c Coordinates)HaversineDistance(c2 Coordinates) float64 {
	// convert lat/long to radians
	lat1Rad := c.Lat * math.Pi / 180
	lon1Rad := c.Lng * math.Pi / 180
	lat2Rad := c2.Lat * math.Pi / 180
	lon2Rad := c2.Lng * math.Pi / 180
	// calculate haversine distance between the two coordinate points
	return 2 * radEarth * math.Asin(math.Sqrt(haversine(lat2Rad - lat1Rad) +
		math.Cos(lat1Rad) * math.Cos(lat2Rad) * haversine(lon2Rad - lon1Rad)))
}

func (c Coordinates)String() string {
	return fmt.Sprintf("%f,%f", c.Lat, c.Lng)
}

func haversine(θ float64) float64 {
	return .5 * (1 - math.Cos(θ))
}
