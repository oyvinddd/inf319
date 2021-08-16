package route

import (
	"delivery/coords"
	"testing"
)

const (
	oneMillion int = 1000000
	tenMillion int = 10000000
	hundredMillion int = 100000000
)

func TestBoundingBox_Contains(t *testing.T) {
	p1 := *coords.New(60.38275538828544,5.330107343472419)
	p2 := *coords.New(60.38399861171454, 5.337799656527579)
	p3 := *coords.New(60.37593738828546,5.33461824347242)
	p4 := *coords.New(60.37718061171456, 5.34231055652758)
	point := *coords.New(60.37942886352539, 5.338179111480713)
	box := NewBoundingBox(p1, p2, p3, p4)
	if !box.Contains(point) {
		t.Errorf("Point %s should be within bounding box", point)
	}
}
