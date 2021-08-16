package restaurant

import (
	"fmt"
)

const (
	BurgerType FoodType = FoodType(0)

	SushiType FoodType = FoodType(1)

	PastaType FoodType = FoodType(2)

	FishType FoodType = FoodType(3)

	SteakType FoodType = FoodType(4)

	PizzaType FoodType = FoodType(5)

	SaladType FoodType = FoodType(6)

	ChickenType FoodType = FoodType(7)

	SquidType FoodType = FoodType(8)

	RamenType FoodType = FoodType(9)

	// MaxFoodTypes the current # of food types in the system
	MaxFoodTypes int = 10

	// discount modifier is multiplied by the normal price
	discountModifier float32 = 0.6
)

var (
	// names of all possible food types in the system
	foodNames = []string{
		"Burger",
		"Sushi",
		"Pasta",
		"Fish",
		"Steak",
		"Pizza",
		"Salad",
		"Chicken",
		"Squid",
		"Ramen",
	}

	// prices of all possible food types in the system
	foodPrices = []float32 {
		159,
		289,
		115,
		120,
		229,
		210,
		89,
		99,
		199,
		59,
	}

	// preparation time of food in minutes
	foodPreparationTime = []int {
		20,
		15,
		15,
		20,
		30,
		15,
		10,
		20,
		25,
		15,
	}

	// expiration time of food in minutes
	foodExpirationTime = []int {
		20,
		20,
		20,
		20,
		20,
		20,
		20,
		20,
		20,
		20,
	}
)
type (
	// Food struct
	Food struct {
		RestaurantID 	int			`json:"restaurant_id"`
		Type 			FoodType 	`json:"type"`
		Name 			string 		`json:"name"`
		LowerPrice 		float32		`json:"lower_price"`
		NormalPrice 	float32		`json:"normal_price"`
		PreparationTime int 		`json:"preparation_time"`
		ExpirationTime 	int 		`json:"expiration_time"`
	}

	// FoodType a dish can have one of ten types
	FoodType uint8
)

// NewFood creates and initializes a new food
func NewFood(restaurantID int, typ FoodType) *Food {
	index := int(typ)
	foodName := foodNames[index]
	normalPrice := foodPrices[index]
	lowerPrice := foodPrices[index] * discountModifier
	prepTime := foodPreparationTime[index]
	expTime := foodExpirationTime[index]
	return &Food{
		RestaurantID: restaurantID,
		Type: typ,
		Name: foodName,
		LowerPrice: lowerPrice,
		NormalPrice: normalPrice,
		PreparationTime: prepTime,
		ExpirationTime: expTime,
	}
}

// String returns a string representation of a food struct
func (f Food)String() string {
	return fmt.Sprintf("%d|%s|%d|%d|%d", f.RestaurantID, f.Name, f.Type, f.NormalPrice, f.LowerPrice)
}
