package route

import (
	"delivery/coords"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
)

const (
	// API Key for contacting the Google Maps API
	apiKey string = "GOOGLE_API_KEY_GOES_HERE"

	// Google Directions service base URL
	baseURL string = "https://maps.googleapis.com/maps/api/directions/json"
)

var (
	errEmptyRouteList = errors.New("empty route list in response")
	errEmptyLegsList = errors.New("empty leg list in response")
)

// private struct that implements the Service interface
type googleService struct {}

// TempRouteResponse is the response structure we receive from Google
// it will eventually be converted into our own structs
type TempRouteResponse struct {
	Routes []struct {
		Legs []struct {
			StartAddress string `json:"start_address"`
			EndAddress string `json:"end_address"`
			StartLocation coords.Coordinates `json:"start_location"`
			EndLocation coords.Coordinates `json:"end_location"`
			Steps []struct{
				StartLocation coords.Coordinates `json:"start_location"`
				EndLocation coords.Coordinates `json:"end_location"`
				Polyline struct {
					Points string `json:"points"`
				} `json:"polyline"`
				Duration struct {
					Value int `json:"value"`
				} `json:"duration"`
				Distance struct {
					Value int `json:"value"`
				} `json:"distance"`
			} `json:"steps"`
		} `json:"legs"`
	} `json:"routes"`
}

// NewGoogleService creates and initializes a new Google service
func NewGoogleService() Service {
	return &googleService{}
}

// CalculatePathFromCoords uses the Google Directions API to calculate a route from two coordinate points
// https://developers.google.com/maps/documentation/directions/get-directions
func (s googleService)CalculatePathFromCoords(start, end coords.Coordinates, mode TravelMode) ([]PathSegment, error) {
	res, err := http.Get(directionsServiceURLWithParams(start, end, mode))
	if err != nil {
		return nil, err
	}
	return PathFromResponseBody(res.Body)
}

// CalculatePathFromAddr uses the Google Directions API to calculate a route from two addresses
func (s googleService)CalculatePathFromAddr(start, end string, mode TravelMode) ([]PathSegment, error) {
	res, err := http.Get(directionsServiceURLWithParams(start, end, mode))
	if err != nil {
		return nil, err
	}
	return PathFromResponseBody(res.Body)
}

// PathFromResponseBody is responsible for converting Google response into our own
// domain specific structs (PathSegment)
func PathFromResponseBody(body io.ReadCloser) ([]PathSegment, error) {
	var trr TempRouteResponse
	if err := json.NewDecoder(body).Decode(&trr); err != nil {
		return nil, err
	}
	if len(trr.Routes) == 0 {
		return nil, errEmptyRouteList
	}
	if len(trr.Routes[0].Legs) == 0 {
		return nil, errEmptyLegsList
	}
	var path []PathSegment
	for index, step := range trr.Routes[0].Legs[0].Steps {
		duration, distance := step.Duration.Value, step.Distance.Value
		path = append(path, NewPathSegment(index, step.StartLocation, step.EndLocation, distance, duration))
	}
	return path, nil
}

// builds the Google directions API URL with parameters
func directionsServiceURLWithParams(start, end interface{}, mode TravelMode) string {
	return fmt.Sprintf("%s?origin=%s&destination=%s&mode=%s&alternatives=false&units=metric&key=%s", baseURL, start, end, mode, apiKey)
}
