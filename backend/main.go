package main

import (
	"delivery/app"
	"delivery/parser"
	"fmt"
	"log"
)

const (
	// server host
	serverHost string = "localhost"
	// server port
	serverPort int = 8084
)

func main() {
	// parse data (restaurants, vehicles and food) from file
	data, err := parser.ParseFile("data.csv")
	if err != nil {
		log.Fatalf("Error parsing CSV file: %s", err.Error())
	}
	// create and start the app (calling Run() starts the HTTP server)
	serverAddr := fmt.Sprintf("%s:%d", serverHost, serverPort)
	fmt.Printf("Starting server on http://%s...\n", serverAddr)
	log.Fatal(app.New(serverAddr, data).Run())
}
