package coords

type Polygon struct {
	Points []Coordinates
}

func NewPolygon(points ...Coordinates) Polygon {
	return Polygon{
		Points: points,
	}
}