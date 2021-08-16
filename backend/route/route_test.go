package route

import (
	"delivery/coords"
	"testing"
)

func TestPathSegment_BoundingCircleContainsCoords(t *testing.T) {
	p1 := *coords.New(60.37689971923828, 5.358949184417725)
	p2 := *coords.New(60.37752914428711, 5.354241847991943)

	p3 := *coords.New(60.38861846923828, 5.346598148345947)
	segment := NewPathSegment(0, p1, p2, 0,0)
	if segment.BoundingCircleContainsCoords(p3) {
		t.Errorf("Wrong! Line segment does not contain the point %s", p3)
	}
}