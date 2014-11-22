package main

import (
	"github.com/go-martini/martini"
	"io/ioutil"
	"fmt"
	"github.com/martini-contrib/cors"
	"net/http"
	"encoding/json"
)
func main() {
	server:= martini.Classic()
	server.Use(martini.Static("../assets"))
	server.Use(cors.Allow(&cors.Options{
		AllowOrigins:     []string{"http://localhost:*", "http://localhost*"},
		AllowMethods:     []string{"POST", "GET"},
		AllowHeaders:     []string{"Origin", "Content-Type"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
	}))
	server.Get("/")
	server.Post("/calculator", Calculate)
	server.Run()
}
type Calculation struct{
	calculation string `json:`
}

func Calculate(response http.ResponseWriter, request *http.Request, params martini.Params) int{
	bodyBytes, err := ioutil.ReadAll(request.Body)
	if err != nil {
		return 500
	}
	var toCalc Calculation
	err = json.Unmarshal(bodyBytes, &toCalc)
	if err != nil {
		return 500
	}
	if toCalc.calculation == "" {
		return 500
	}
	fmt.Printf(string(bodyBytes))
	responseBytes, err := json.Marshal(toCalc)
	if err != nil {
		return 500
	}
	fmt.Fprint(response, string(responseBytes))
	return 200
}

