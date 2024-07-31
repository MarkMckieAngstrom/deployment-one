package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "<h1>%s %s %s</h1>\n", r.Method, r.URL, r.Proto)

	// Iterate over all header fields
	fmt.Fprintf(w, "<h2>Headers:</h2>\n<ul>")
	for k, v := range r.Header {
		fmt.Fprintf(w, "<li><strong>%s</strong>: %s</li>\n", k, strings.Join(v, ", "))
	}
	fmt.Fprintf(w, "</ul>")
}

func timeZone(name string) *time.Location {
	loc, err := time.LoadLocation(name)
	if err != nil {
		loc = time.FixedZone(name, 0)
	}
	return loc
}

func main() {
	http.HandleFunc("/", handler)
	log.Fatal(http.ListenAndServe(":8090", nil))
}