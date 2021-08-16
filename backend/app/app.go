package app

import (
	"delivery/data"
	"delivery/handler"
	"delivery/route"
	"github.com/gorilla/handlers"
	"github.com/gorilla/mux"
	"net/http"
	"os"
	"time"
)

const (
	// server read timeout in seconds
	serverReadTimeout = time.Second * 15

	// server write timeout in seconds
	serverWriteTimeout = time.Second * 15
)

// App is the outer layer of the system
type App struct {
	server *http.Server
	data *data.Container
}

// New creates and initializes a new app
func New(addr string, data data.Container) *App {
	// create and init http server with router
	server := newServer(addr, newRouter(&data))
	return &App{data: &data, server: server}
}

// Run starts the app and blocks
func (a App)Run() error {
	return a.server.ListenAndServe()
}

// creates a new HTTP server
func newServer(addr string, handler http.Handler) *http.Server {
	return &http.Server{
		ReadTimeout: serverReadTimeout,
		WriteTimeout: serverWriteTimeout,
		Handler: handler,
		Addr: addr,
	}
}

// creates a new HTTP router with handlers for all valid endpoints
func newRouter(data *data.Container) http.Handler {
	// services
	routeService := route.NewGoogleService()
	// http handlers responsible for handling any calls to REST endpoints
	orderHandler := handler.NewOrderHandler(routeService, data)
	dataHandler := handler.NewDataHandler(data)
	routeHandler := handler.NewRouteHandler(data)
	// make our route handler observe for changes in the data
	data.AddListener(&routeHandler)
	// router takes care of resolving URL request
	router := mux.NewRouter().StrictSlash(false)
	router.HandleFunc(ordersPath, orderHandler.CreateOrder).Methods(http.MethodPost)
	router.HandleFunc(ordersPath, orderHandler.GetOrders).Methods(http.MethodGet)
	router.HandleFunc(dataPath, dataHandler.ListData).Methods(http.MethodGet)
	router.HandleFunc(restaurantsPath, dataHandler.ListRestaurants).Methods(http.MethodGet)
	router.HandleFunc(wsConnectPath, routeHandler.Connect).Methods(http.MethodGet)
	router.HandleFunc(routesPath, routeHandler.GetRoutes).Methods(http.MethodGet)
	// html/static assets route
	fileServer := http.FileServer(http.Dir("." + staticFileDir))
	router.PathPrefix(staticFileDir).Handler(http.StripPrefix(staticFileDir, fileServer))
	// add simple HTTP request logging
	loggedRouter := handlers.LoggingHandler(os.Stdout, router)
	return loggedRouter
}
