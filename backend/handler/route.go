package handler

import (
	"delivery/data"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
)

const (
	// read buffer size in bytes
	readBufSize int = 1024
	// write buffer size in bytes
	writeBufSize int = 1024
)

// RouteHandler is responsible for sending route data to the client through websockets/HTTP
type RouteHandler struct {
	upgrader websocket.Upgrader
	clients map[*websocket.Conn]bool
	data *data.Container
}

// NewRouteHandler creates and initializes a route handler
func NewRouteHandler(data *data.Container) RouteHandler {
	upgrader := websocket.Upgrader{
		ReadBufferSize:    readBufSize,
		WriteBufferSize:   writeBufSize,
		EnableCompression: false,
		CheckOrigin:       nil,
	}
	return RouteHandler{
		upgrader: upgrader,
		clients: make(map[*websocket.Conn]bool),
		data: data,
	}
}

// Connect listens for incoming websocket connection requests from clients
func (h *RouteHandler)Connect(w http.ResponseWriter, r *http.Request) {
	client, err := h.upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Printf("Websocket upgrade failed: %s\n", err.Error())
		return
	}
	// add active connection to map
	h.clients[client] = true
}

// GetRoutes responds to clients with all active routes in the system
func (h RouteHandler)GetRoutes(w http.ResponseWriter, r *http.Request) {
	respondWithJSON(w, http.StatusOK, h.data.Routes)
}

// NotifyCallback is called whenever certain types of events arise in the system
func (h RouteHandler)NotifyCallback(event data.Event) {
	switch event.EvtType {
	case data.RouteCreatedEvent:
		h.broadcast(event.Payload)
	case data.RoutesDeletedEvent:
		h.broadcast(map[string]string{
			"event": "routes_deleted",
		})
	}
}

// broadcasts data to all connected clients
func (h *RouteHandler)broadcast(data interface{}) {
	for client := range h.clients {
		if err := client.WriteJSON(data); err != nil {
			client.Close()
			delete(h.clients, client)
		}
	}
}
