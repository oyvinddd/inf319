package data

const (
	// RouteCreatedEvent a new route has been created
	RouteCreatedEvent = EventType(0)
	// RoutesDeletedEvent all active routes has been deleted
	RoutesDeletedEvent = EventType(1)
)

type (
	// Observer listens for changes to a subject
	Observer interface {
		NotifyCallback(Event)
	}

	// Subject notifies any observers of changes
	Subject interface {
		AddListener(Observer)
		RemoveListener(Observer)
		Notify(Event)
	}

	// Event is passed to the observer upon notification
	Event struct {
		EvtType EventType
		Payload interface{}
	}

	// EventType is the type of incoming event
	EventType uint
)

// NewEvent creates and initializes an event
func NewEvent(eventType EventType, payload interface{}) Event {
	return Event{EvtType: eventType, Payload: payload}
}
