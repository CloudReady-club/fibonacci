package main

import (
	"fmt"
	"io"
	"log"
	"math/big"
	"net/http"
	"strconv"
	"time"
)

func main() {
	fmt.Println("starting Server  at port 8080")
	http.HandleFunc("/fibonacci", getFibonacci)
	http.HandleFunc("/healthz", getHealthzt)

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal(err)
	}

}

func getHealthzt(response http.ResponseWriter, request *http.Request) {
	io.WriteString(response, "Ok")
}

func getFibonacci(response http.ResponseWriter, request *http.Request) {
	startTime := time.Now().UTC()
	fibonacci()
	endTime := time.Now().UTC()
	duration := endTime.Sub(startTime).Milliseconds()

	io.WriteString(response, strconv.FormatInt(duration, 10))
	io.WriteString(response, " ms")

}

func fibonacci() *big.Int {

	// Initialize two big ints with the first two numbers in the sequence.
	a := big.NewInt(0)
	b := big.NewInt(1)

	// Initialize limit as 10^9999, the smallest integer with 10 000 digits.
	var limit big.Int
	limit.Exp(big.NewInt(10), big.NewInt(9999), nil)

	// Loop while a is smaller than 1e100.
	for a.Cmp(&limit) < 0 {
		// Compute the next Fibonacci number, storing it in a.
		a.Add(a, b)
		// Swap a and b so that b is the next number in the sequence.
		a, b = b, a
	}

	return a
}
