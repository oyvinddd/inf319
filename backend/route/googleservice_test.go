package route

import (
	"delivery/coords"
	"testing"
)

func TestGoogleService_CalculateRouteFromCoords(t *testing.T) {
	// home
	c1 := *coords.New(60.382778, 5.316600)
	// school
	c2 := *coords.New(60.381490, 5.331600)
	_, err := NewGoogleService().CalculatePathFromCoords(c1, c2, DrivingMode)
	if err != nil {
		t.Errorf("Error calculating path: %s", err.Error())
	}
}
