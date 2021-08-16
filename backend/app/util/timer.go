package util

import (
	"fmt"
	"time"
)

// Timer for timing program/algorithm execution
type Timer struct {
	start time.Time
	end   time.Time
}

// NewTimer creates and initializes a new timer
func NewTimer() *Timer {
	return &Timer{
		start: time.Now(),
	}
}

// Start the timer
func (t *Timer)Start() {
	t.start = time.Now()
}

// PrintElapsed prints time to the terminal
func (t *Timer)PrintElapsed() {
	fmt.Printf("### Program execution took: %v ms ###\n", time.Since(t.start).Milliseconds())
}
