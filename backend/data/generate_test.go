package data

import (
	"fmt"
	"testing"
)

func TestCreateRestaurants(t *testing.T) {
	/*
	r := CreateRestaurants(100)
	for _, rest := range r {
		fmt.Println(rest)
	}
	 */
}

func TestGenerateCustomers(t *testing.T) {
	c := GenerateCustomers(100)
	for _, cust := range c {
		fmt.Println(cust)
	}
}

func TestGenerateFood(t *testing.T) {
	f := GenerateFood(100)
	for num, food := range f {
		fmt.Printf("%d|%s\n", num / 3, food)
	}
}
