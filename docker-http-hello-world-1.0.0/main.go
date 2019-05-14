package main

import "net/http"
import "fmt"
import "log"

func main() {
	http.HandleFunc(
		"/",
		func (w http.ResponseWriter, r *http.Request) {
			fmt.Fprintln(w, "Hello, world.")
		})
	log.Fatal(http.ListenAndServe(":8080", nil))
}