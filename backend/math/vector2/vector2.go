package vector2

import "math"

// Vector2 is represented by a magnitude and a direction
type Vector2 struct {
	X, Y  float64
}

// New creates and initializes a new vector
func New(x, y float64) Vector2 {
	return Vector2{X: x, Y: y}
}

// Length calculates the length of the vector using the euclidean distance formula
func (v Vector2)Length() float64 {
	return math.Sqrt(math.Pow(v.X, 2) + math.Pow(v.Y, 2))
}

// Magnitude is an alias for the Length function
func (v Vector2)Magnitude() float64 {
	return v.Length()
}

// Multiply vector by a given scalar
func (v Vector2)Multiply(scalar float64) Vector2 {
	return New(v.X * scalar, v.Y * scalar)
}

// Add two vectors together
func (v Vector2)Add(other Vector2) Vector2 {
	return New(v.X + other.X, v.Y + other.Y)
}

// Dot calculates the dot product of two vectors
func (v Vector2)Dot(other Vector2) float64 {
	return v.X * other.X + v.Y * other.Y
}

// Equals checks if two vectors are equal
func (v Vector2)Equals(other Vector2) bool {
	return v.X == other.X && v.Y == other.Y
}
