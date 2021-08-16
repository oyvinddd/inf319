package geometry

import (
	"fmt"
	"math"
)

type (
	// Point represents a point in 2d space represented by x and y coordinates
	Point struct {
		X, Y float64
	}

	// Line represents a line in 2d space represented by two points
	Line struct {
		Slope, YInt float64
		P1, P2 Point
	}

	// Circle represents a circle in 2d space
	// x^2 + y^2 = r^2 is the standard equation of a circle drawn at the origin
	// with translation that gives us (x - h)^2 + (y - k)^2 = r^2
	Circle struct {
		Center Point
		Radius float64
	}
)

func NewPoint(x, y float64) Point {
	return Point{X: x, Y: y}
}

func NewLine(slope float64, yIntersect float64) Line {
	return Line{Slope: slope, YInt: yIntersect}
}

func LineFromPoints(p1, p2 Point) Line {
	slope := (p2.Y - p1.Y) / (p2.X - p1.X)
	yInt := p1.Y - slope * p1.X
	return Line{
		Slope: slope,
		YInt: yInt,
		P1: p1,
		P2: p2,
	}
}

func NewCircle(center Point, radius float64) Circle {
	return Circle{Center: center, Radius: radius}
}

func (p Point)String() string {
	return fmt.Sprintf("(%f, %f)", p.X, p.Y)
}

func (line Line)String() string {
	return fmt.Sprintf("Slope: %f, Y-intercept: %f", line.Slope, line.YInt)
}

func (circle Circle)IntersectingPoints(line Line) (Point, Point) {
	/*
	Circle: (x - 2)^2 + (y + 3)^2 = 4
	Line: 	2x + 2y = -1

	h and k = the coordinates of the center of the circle
	r = radius of the circle
	m = slope of the line
	b = y-intercept of the line
	*/
	h := circle.Center.X
	k := circle.Center.Y
	r := circle.Radius
	m, b := line.Slope, line.YInt

	A := 1+m*m
	B := -2*h+2*m*b-2*k*m
	C := h*h+b*b+k*k-2*k*b-r*r

	dt := B*B-4*A*C

	x1 := (-B+math.Sqrt(dt))/(2*A)
	x2 := (-B-math.Sqrt(dt))/(2*A)
	y1 := m*x1+b
	y2 := m*x2+b

	p1 := NewPoint(x1, y1)
	p2 := NewPoint(x2, y2)

	return p1, p2
}

// MiddlePoint finds the point in the middle of a line defined by two points
func (line Line)MiddlePoint() Point {
	return Point{X: (line.P1.X + line.P2.X) / 2, Y: (line.P1.Y + line.P2.Y) / 2}
}

// Perpendicular creates a new line that is perpendicular
// to the original line and passes through the given point
func (line Line)Perpendicular(point Point) Line {
	slope := math.Pow(line.Slope, -1) * -1
	yInt := point.Y - slope * point.X
	return NewLine(slope, yInt)
}

func (line Line)Parallel(point Point) Line {
	// TODO: implement this
	return Line{}
}

// QuadraticEq solves equations on the form: ax^2 + bx + c = 0
func QuadraticEq(a, b, c float64) (float64, float64) {
	// discriminant
	var d = math.Pow(b,2) - (4 * a * c)
	// calculate the two solutions
	s1 := (-b-math.Sqrt(d)) / (2 * a)
	s2 := (-b+math.Sqrt(d)) / (2 * a)
	return s1, s2
}
