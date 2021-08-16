package data

import (
	"delivery/coords"
	"delivery/customer"
	"delivery/restaurant"
	"fmt"
	"math/rand"
	"time"
)

func init() {
	// need to seed the random function or else it
	// generates the same values on each run
	rand.Seed(time.Now().UnixNano())
}

func GenerateRestaurants(num int) []*restaurant.Restaurant {
	points := GenerateRandomCoords(num)
	var restaurants []*restaurant.Restaurant
	for i := 0; i < num; i++ {
		rest := restaurant.New(i + 1, fmt.Sprintf("Restaurant %d", i + 1), points[i])
		restaurants = append(restaurants, rest)
	}
	return restaurants
}

func GenerateCustomers(num int) []*customer.Customer {
	points := GenerateRandomCoords(num)
	var customers []*customer.Customer
	for i := 0; i < num; i++ {
		customer := customer.New(i + 1, fmt.Sprintf("Customer #%d", i + 1), points[i])
		customers = append(customers, customer)
	}
	return customers
}

func GenerateFood(num int) []*restaurant.Food {
	food, menuSize := make([]*restaurant.Food, 0), 3
	for i := 0; i < num * menuSize; i++ {
		rand := rand.Intn(restaurant.MaxFoodTypes)
		food = append(food, restaurant.NewFood(0, restaurant.FoodType(rand)))
	}
	return food
}

func GenerateRandomCoords(num int) []coords.Coordinates {
	var points []coords.Coordinates
	// these coordinates represents a box around the Bergen area
	maxLat, minLat := 60.403736, 60.376822
	maxLng, minLng := 5.364611, 5.297350
	// generate num number of points
	for i := 0; i < num; i++ {
		rLat := minLat + rand.Float64()*(maxLat-minLat)
		rLng := minLng + rand.Float64()*(maxLng-minLng)
		points = append(points, *coords.New(rLat, rLng))
	}
	return points
}
