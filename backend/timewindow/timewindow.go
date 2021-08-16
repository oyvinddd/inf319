package timewindow

import "time"

// TimeWindow has a lower and upper timestamp
type TimeWindow struct {
	Lower time.Time `json:"lower"`
	Upper time.Time `json:"upper"`
}

// New creates a new time window with upper and lower timestamps
func New(lower time.Time, upper time.Time) *TimeWindow {
	return &TimeWindow{
		Lower: lower,
		Upper: upper,
	}
}
