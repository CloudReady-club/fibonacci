package main

import (
	"io"
	"log"
	"math/big"
	"net/http"
	"strconv"
	"time"
)

func main() {

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

	a := big.NewInt(0)
	b := big.NewInt(1)

	var limit big.Int
	limit.Exp(big.NewInt(10), big.NewInt(9999), nil)
	for a.Cmp(&limit) < 0 {
		a.Add(a, b)
		a, b = b, a
	}

	return a
}
