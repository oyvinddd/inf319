package route

import (
	"delivery/coords"
	"delivery/math/vector2"
	"fmt"
	"math"
)

// BoundingBox is the set of points forming a rectangle around a given path segment (line)
type BoundingBox struct {
	Point1 coords.Coordinates `json:"p1"`
	Point2 coords.Coordinates `json:"p2"`
	Point3 coords.Coordinates `json:"p3"`
	Point4 coords.Coordinates `json:"p4"`
}

// NewBoundingBox creates and initializes a new bounding box
func NewBoundingBox(p1, p2, p3, p4 coords.Coordinates) BoundingBox {
	return BoundingBox{Point1: p1, Point2: p2, Point3: p3, Point4: p4}
}

// BoundingBoxForLine creates a bounding box around a given line
// https://gis.stackexchange.com/questions/29664/given-a-line-on-the-earths-surface-how-do-i-plot-a-line-perpendicular-to-it/29713#29713?newreg=53f919cb17104dc88607b3bb220eea97
func BoundingBoxForLine(c1, c2 coords.Coordinates) BoundingBox {
	// 1. multiply longitude by the cosine of a typical latitude
	// a typical latitude in our case is the average latitude
	// between our two current coordinates
	avgLat := (c1.Lat + c2.Lat) / 2
	cosLat := math.Cos(avgLat * math.Pi / 180)
	// adjusted coordinates
	c1.Lng *= cosLat
	c2.Lng *= cosLat
	// 2. compute perpendicular lines (using vector arithmetic)
	v := vector2.New(c2.Lng - c1.Lng, c2.Lat - c1.Lat)
	w := vector2.New(v.Y, v.X * -1)
	latOffset := BoundingBoxDistanceDegrees / w.Length() * w.Y
	lngOffset := BoundingBoxDistanceDegrees / w.Length() * w.X
	c3 := *coords.New(c1.Lat + latOffset, c1.Lng + lngOffset)
	c4 := *coords.New(c1.Lat - latOffset, c1.Lng - lngOffset)
	c5 := *coords.New(c2.Lat + latOffset, c2.Lng + lngOffset)
	c6 := *coords.New(c2.Lat - latOffset, c2.Lng - lngOffset)
	// 3. undo adjustment for each latitude by dividing by cos(latitude)
	c3.Lng /= cosLat
	c4.Lng /= cosLat
	c5.Lng /= cosLat
	c6.Lng /= cosLat
	return NewBoundingBox(c3, c4, c5, c6)
}

// Contains checks if a given coordinate is within the bounds of the box
func (b BoundingBox)Contains(c coords.Coordinates) bool {
	// first adjust our longitudes to take into account the curvature of the earth
	avgLat := (b.Point1.Lat + b.Point2.Lat + b.Point3.Lat + b.Point4.Lat) / 4
	cosLat := math.Cos(avgLat * math.Pi / 180)
	b.Point1.Lng = b.Point1.Lng * cosLat
	b.Point2.Lng = b.Point2.Lng * cosLat
	b.Point3.Lng = b.Point3.Lng * cosLat
	b.Point4.Lng = b.Point4.Lng * cosLat
	c.Lng = c.Lng * cosLat
	// we can now do calculations like we normally would on a flat 2D plane
	// define our rectangle ABC: A = p1, B = p2, C = p4, M = input point
	ab := vector2.New(b.Point2.Lng - b.Point1.Lng, b.Point2.Lat - b.Point1.Lat)
	bc := vector2.New(b.Point4.Lng - b.Point2.Lng, b.Point4.Lat - b.Point2.Lat)
	am := vector2.New(c.Lng - b.Point1.Lng, c.Lat - b.Point1.Lat)
	bm := vector2.New(c.Lng - b.Point2.Lng, c.Lat - b.Point2.Lat)
	// calculate dot products
	dotAbAb := ab.Dot(ab)
	dotBcBc := bc.Dot(bc)
	dotAbAm := ab.Dot(am)
	dotBcBm := bc.Dot(bm)
	return 0 <= dotAbAm && dotAbAm <= dotAbAb && 0 <= dotBcBm && dotBcBm <= dotBcBc
}

func (b BoundingBox)String() string {
	return fmt.Sprintf("Bounding box: (%s | %s | %s | %s)", b.Point1, b.Point2, b.Point3, b.Point4)
}
