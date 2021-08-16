package coords

import (
	"fmt"
	"testing"
)

func TestCoordinates_Distance(t *testing.T) {

	c1 := *New(2, 2)
	c2 := *New(2, 2)
	c3 := *New(1, 1)
	c4 := *New(2, 2)
	c5 := *New(60.382778, 5.316600)
	c6 := *New(60.381490, 5.331600)

	d1 := c1.Distance(c2)
	d2 := c3.Distance(c4)
	d3 := c5.Distance(c6)

	fmt.Printf("Distance from home to school: %f", d3)

	if d1 != 0.0 {
		t.Errorf("Expected distance (0.0) is wrong: %f", d1)
	}
	if d2 != 1.4142135623730951 {
		t.Errorf("Expected distance (1.4142135623730951) is wrong: %f", d2)
	}
}

func TestCoordinates_HaversineDistance(t *testing.T) {
	c1 := *New(60.38144989999999, 5.3198441)
	c2 := *New(60.3776917, 5.330869499999999)
	distance := 736.2747331746176
	if c1.HaversineDistance(c2) != distance {
		t.Errorf("Haversine distance is wrong")
	}
}
