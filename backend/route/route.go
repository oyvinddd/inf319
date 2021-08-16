package route

import (
	"delivery/coords"
	"delivery/order"
	"delivery/restaurant"
	"delivery/vehicle"
	"errors"
	"math"
)

const (
	// BoundingBoxDistanceDegrees in this case dictates the distance of the bounding box from the path
	BoundingBoxDistanceDegrees float64 = 0.002

	// BoundingCircleDegrees dictates the distance of the radius for the bounding circle
	BoundingCircleDegrees float64 = 0.002

	// OneDegreeInKm is the conversion rate 1 deg = 111 km at the equator
	OneDegreeInKm float64 = 111

	// OneDegreeInM is the conversion rate 1 deg = 111 000 m at the equator
	OneDegreeInM float64 = 111000
)

var (
	errMaxCapacityReached = errors.New("max vehicle capacity reached for route")
	errInvalidOrigOrDest = errors.New("route has invalid origin or destination")
	errInvalidPathNumber = errors.New("path with given number does not exist")
)

type (
	// Route the route a vehicle must travel to deliver its content
	Route struct {
		ID 			int							`json:"id"`
		Path 		[]PathSegment				`json:"path"`
		Vehicle 	vehicle.Vehicle				`json:"vehicle"`
		Orders 		[]*order.Order 				`json:"orders"`
		Offers 		[]*restaurant.SpecialOffer	`json:"offers"`
		AvgSpeed 	int							`json:"avg_speed"`
		Duration	int							`json:"duration"`
	}

	// PathSegment two points forming a straight line in the route
	PathSegment struct {
		Number			int					`json:"-"`
		Start			coords.Coordinates	`json:"start"`
		End				coords.Coordinates	`json:"end"`
		Distance		int					`json:"distance"` // distance in meters
		Duration		int					`json:"duration"` // duration in seconds
		Box				BoundingBox			`json:"box"`
		CircleRadius 	float64				`json:"circle_radius"`
	}
)

// New creates and initializes a new route
func New(path []PathSegment, vehicle vehicle.Vehicle, ord *order.Order) *Route {
	duration, speed := calculateTotalDuration(path), calculateAverageSpeed(path)
	return &Route{Path: path, Vehicle: vehicle, Orders: []*order.Order{ord}, AvgSpeed: speed, Duration: duration}
}

// NewPathSegment creates and initializes a new path segment (a part of a route)
func NewPathSegment(number int, start, end coords.Coordinates, distance, duration int) PathSegment {
	boundingBox := BoundingBoxForLine(start, end)
	radiusMeters := BoundingCircleDegrees
	return PathSegment{
		Number: number,
		Start: start,
		End: end,
		Distance: distance,
		Duration: duration,
		Box: boundingBox,
		CircleRadius: radiusMeters,
	}
}

// BoundingCircleContainsCoords checks if the two bounding circles for
// each point in the path segment contains a given point
func (s PathSegment)BoundingCircleContainsCoords(c coords.Coordinates) bool {
	// convert the latitudes to take into account the curvature of the earth
	avgLat := (s.Start.Lat + s.End.Lat + c.Lat) / 3
	cosLat := math.Cos(avgLat * math.Pi / 180)
	s.Start.Lng *= cosLat
	s.End.Lng *= cosLat
	c.Lng *= cosLat
	// check if point is within either the starting or the ending point of the path segment
	circleRadSq := math.Pow(s.CircleRadius, 2)
	startCircleContains := math.Pow(c.Lng - s.Start.Lng, 2) + math.Pow(c.Lat - s.Start.Lat, 2) < circleRadSq
	endCircleContains := math.Pow(c.Lng - s.End.Lng, 2) + math.Pow(c.Lat - s.End.Lat, 2) < circleRadSq
	return startCircleContains || endCircleContains
}

// AddOrder adds a new order to the existing route
func (r *Route)AddOrder(order *order.Order) error {
	if len(r.Orders) < r.Vehicle.Capacity {
		r.Orders = append(r.Orders, order)
		return nil
	}
	return errMaxCapacityReached
}

// ClosestSegment finds the path segment closest to the given coordinate point (length in meters is returned as well)
func (r Route)ClosestSegment(c coords.Coordinates) (PathSegment, float64) {
	var pathSegment PathSegment
	var minLength = math.MaxFloat64
	for _, segment := range r.Path {
		distanceFromStart := segment.Start.HaversineDistance(c)
		distanceFromEnd := segment.End.HaversineDistance(c)
		if  distanceFromStart < minLength {
			minLength = distanceFromStart
			pathSegment = segment
		}
		if distanceFromEnd < minLength {
			minLength = distanceFromEnd
			pathSegment = segment
		}
	}
	return pathSegment, minLength
}

// DurationFromSegment calculates the remaining time (in minutes) of the route from the given segment
func (r Route)DurationFromSegment(segmentNumber int) (int, error) {
	if segmentNumber < 0 || segmentNumber >= len(r.Path) {
		return -1, errInvalidPathNumber
	}
	var totalTime int
	for i := segmentNumber; i < len(r.Path); i++ {
		totalTime += r.Path[i].Duration
	}
	return totalTime, nil
}

// DurationBetweenSegments returns the total time (in seconds) from one segment to another on the route
func (r Route)DurationBetweenSegments(segment1 int, segment2 int) int {
	duration := 0
	minSegment, maxSegment := segment1, segment2
	if minSegment > maxSegment {
		tempSegment := minSegment
		minSegment = maxSegment
		maxSegment = tempSegment
	}
	for i := minSegment; i <= maxSegment; i++ {
		duration += r.Path[i].Duration
	}
	return duration
}

// IsEqual checks if two routes are equal based in the origin and destination locations
func (r *Route)IsEqual(otherRoute *Route) bool {
	if r == nil || otherRoute == nil || len(r.Orders) == 0 || len(otherRoute.Orders) == 0 {
		return false
	}
	r1ID := r.Orders[0].Origin.ID
	c1ID := r.Orders[0].Destination.ID
	r2ID := otherRoute.Orders[0].Origin.ID
	c2ID := otherRoute.Orders[0].Destination.ID
	return r1ID == r2ID && c1ID == c2ID
}

// calculates a vehicles average speed (meters per second) for a given route
func calculateAverageSpeed(path []PathSegment) int {
	distance, duration := 0, 0
	for _, segment := range path {
		distance += segment.Distance
		duration += segment.Duration
	}
	return distance / duration
}

// calculate the total duration (in seconds) of the whole route
func calculateTotalDuration(path []PathSegment) int {
	totalDuration := 0
	for _, segment := range path {
		totalDuration += segment.Duration
	}
	return totalDuration
}

