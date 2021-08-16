package parser

import (
	"bufio"
	"delivery/coords"
	"delivery/customer"
	"delivery/data"
	"delivery/restaurant"
	"delivery/vehicle"
	"errors"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

const (
	restaurantsStep uint = 1
	customersStep uint = 2
	foodStep uint = 3
	vehiclesStep uint = 4
)

var (
	errWrongLineFormat = errors.New("line is not formatted correctly")
	errWrongLineValues = errors.New("line has incorrect values")

	currentStep uint = 0
)

// ParseFile parses a given CSV file from the file system and creates a data container from it
func ParseFile(filename string) (data.Container, error) {
	path, err := filepath.Abs("data/" + filename)
	fh, err := os.Open(path)
	if err != nil {
		return data.Container{}, err
	}
	defer fh.Close()

	var restaurants []*restaurant.Restaurant
	var vehicles []*vehicle.Vehicle
	var customers []*customer.Customer

	scanner := bufio.NewScanner(fh)
	for scanner.Scan() {
		line := scanner.Text()
		if isComment(line) {
			currentStep++
			continue
		}
		switch currentStep {
		case restaurantsStep:
			restaurant, err := parseRestaurant(line)
			if err != nil {
				return data.Container{}, err
			}
			restaurants = append(restaurants, restaurant)
		case customersStep:
			customer, err := parseCustomer(line)
			if err != nil {
				return data.Container{}, err
			}
			customers = append(customers, customer)
		case foodStep:
			food, err := parseFood(line)
			if err != nil {
				return data.Container{}, err
			}
			restaurants[food.RestaurantID - 1].Menu = append(restaurants[food.RestaurantID - 1].Menu, *food)
		case vehiclesStep:
			vehicle, err := parseVehicle(line)
			if err != nil {
				return data.Container{}, err
			}
			vehicles = append(vehicles, vehicle)
		}
	}
	return data.New(restaurants, vehicles, customers), err
}

// parse restaurant details from a given line
func parseRestaurant(line string) (*restaurant.Restaurant, error) {
	parts, err := splitLine(line, 4)
	if err != nil {
		return nil, err
	}
	id, err := strconv.Atoi(parts[0])
	name := parts[1]
	lat, err := strconv.ParseFloat(parts[2], 32)
	lon, err := strconv.ParseFloat(parts[3], 32)
	if err != nil {
		return nil, errWrongLineValues
	}
	restaurant := restaurant.New(id, name, *coords.New(lat, lon))
	return restaurant, nil
}

// parse vehicle details from a given line
func parseVehicle(line string) (*vehicle.Vehicle, error) {
	parts, err := splitLine(line, 5)
	if err != nil {
		return nil, err
	}
	id, err := strconv.Atoi(parts[0])
	name := parts[1]
	cap, err := strconv.Atoi(parts[2])
	lat, err := strconv.ParseFloat(parts[3], 32)
	lon, err := strconv.ParseFloat(parts[4], 32)
	if err != nil {
		return nil, errWrongLineValues
	}
	vehicle := vehicle.New(id, name, int(cap), *coords.New(lat, lon))
	return vehicle, nil
}

// parse customer details from a given line
func parseCustomer(line string) (*customer.Customer, error) {
	parts, err := splitLine(line, 4)
	if err != nil {
		return nil, err
	}
	id, err := strconv.Atoi(parts[0])
	name := parts[1]
	lat, err := strconv.ParseFloat(parts[2], 32)
	lon, err := strconv.ParseFloat(parts[3], 32)
	if err != nil {
		return nil, errWrongLineValues
	}
	return customer.New(id, name, *coords.New(lat, lon)), nil
}

// parse food details from a given line
func parseFood(line string) (*restaurant.Food, error) {
	parts, err := splitLine(line, 5)
	if err != nil {
		return nil, err
	}
	rID, err := strconv.Atoi(parts[0])
	typ, err := strconv.Atoi(parts[2])
	if err != nil {
		return nil, errWrongLineValues
	}
	rID++ // CSV file has food with restaurant IDs starting from idx 0, which is wrong
	return restaurant.NewFood(rID, restaurant.FoodType(typ)), nil
}

// split line into `num` parts
func splitLine(line string, num int) ([]string, error) {
	parts := strings.Split(line, "|")
	if len(parts) != num {
		return nil, errWrongLineFormat
	}
	return parts, nil
}

// checks if a given line is a comment or not
func isComment(line string) bool {
	return len(line) > 0 && line[0] == []byte("%")[0]
}
