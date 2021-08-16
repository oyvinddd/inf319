package geometry

import (
	"testing"
)

func TestQuadraticEquation(t *testing.T) {
	x1, x2 := QuadraticEq(1, 5, 6)
	if x1 != -3 || x2 != -2 {
		t.Errorf("Wrong values for x1 (%f) or x2 (%f): ", x1, x2)
	}
}

func TestCircle_IntersectingPoints(t *testing.T) {
	// this circle is centered at the origin
	p1, p2 := NewCircle(NewPoint(0, 0), 1).IntersectingPoints(NewLine(0, 0))
	if p1.X != 1.000000 || p1.Y != 0.000000 || p2.X != -1.000000 || p2.Y != 0.000000 {
		t.Errorf("Wrong values for points: %s and %s", p1, p2)
	}
	// this circle is centered at the origin
	p3, p4 := NewCircle(NewPoint(0, 0), 3).IntersectingPoints(NewLine(-1, 3))
	if p3.X != 3.000000 || p3.Y != 0.000000 || p4.X != 0.000000 || p4.Y != 3.000000 {
		t.Errorf("Wrong values for points: %s and %s", p3, p4)
	}
	// this circle has an offset of x = -1 from the origin
	p5, p6 := NewCircle(NewPoint(-1, 0), 4).IntersectingPoints(NewLine(-1, 3))
	if p5.X != 3.000000 || p5.Y != 0.000000 || p6.X != -1.000000 || p6.Y != 4.000000 {
		t.Errorf("Wrong values for points: %s and %s", p5, p6)
	}
}

func TestLine_Perpendicular(t *testing.T) {
	line := NewLine(1, -3)
	point := NewPoint(2, -1)
	newLine := line.Perpendicular(point)
	if newLine.Slope != -1 || newLine.YInt != 1 {
		t.Errorf("Wrong values for line: %s", newLine)
	}
}
