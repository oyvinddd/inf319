package vector2

import (
	"testing"
)

func TestVector2_Length(t *testing.T) {
	v := New(3, -7)
	length := v.Length()
	expectedLength := 7.615773105863909
	if length != expectedLength {
		t.Errorf("Wrong length for vector: %f", length)
	}
}

func TestVector2_Magnitude(t *testing.T) {
	length := New(2, -10).Length()
	magnitude := New(2, -10).Magnitude()
	if length != magnitude {
		t.Errorf("Magnitude and length is different! Magnitude: %f, Length: %f", magnitude, length)
	}
}

func TestVector2_Dot(t *testing.T) {
	v := New(2, 5)
	w := New(7, 1)
	result := v.Dot(w)
	expectedResult := 19.0
	if result != expectedResult {
		t.Errorf("Wrong dot product: %f. Should be: %f", result, expectedResult)
	}
}