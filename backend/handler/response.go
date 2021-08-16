package handler

import (
	"encoding/json"
	"net/http"
)

// respond to the client with an HTTP status code and a JSON encoded body
func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(&payload)
}

// responds to the client with an HTTP status code and an empty body
func respondWithStatus(w http.ResponseWriter, code int) {
	w.WriteHeader(code)
	w.Write([]byte(nil))
}

// responds to the client with an HTTP status code and a JSON encoded error message
func respondWithError(w http.ResponseWriter, code int, message string) {
	respondWithJSON(w, code, map[string]string{"error": message})
}
