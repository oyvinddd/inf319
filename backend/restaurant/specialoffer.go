package restaurant

import (
	"delivery/timewindow"
	"fmt"
	"time"
)

// MaxOfferDuration is the time an offer is visible to the end user
const MaxOfferDuration = time.Minute * 5

// SpecialOffer is a discounted food item provided by a given
// restaurant based on certain criteria
type SpecialOffer struct {
	ID				int						`json:"id"`
	CustomerID		int						`json:"customer_id"`
	Price			float32					`json:"price"`
	Food 			Food					`json:"food"`
	Window			timewindow.TimeWindow	`json:"-"`
}

// NewSpecialOffer creates and initializes a special offer
func NewSpecialOffer(id int, food Food, customerID int) *SpecialOffer {
	lower := time.Now().UTC()
	upper := lower.Add(MaxOfferDuration)
	window := timewindow.TimeWindow{Lower: lower, Upper: upper}
	return &SpecialOffer{
		ID:         id,
		Price: 		food.LowerPrice,
		Food:       food,
		CustomerID: customerID,
		Window: 	window,
	}
}

// String returns a string representation of a special offer
func (o SpecialOffer)String() string {
	return fmt.Sprintf("(%d, %d)", o.Food.RestaurantID, o.CustomerID)
}
