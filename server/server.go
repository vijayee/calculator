package main

import (
	"github.com/go-martini/martini"
	"io/ioutil"
	"fmt"
	"github.com/martini-contrib/cors"
	"net/http"
	"encoding/json"
	"github.com/robertkrimen/otto"
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
	Calculation string
	Result float64
}

func Calculate(response http.ResponseWriter, request *http.Request, params martini.Params){
	bodyBytes, err := ioutil.ReadAll(request.Body)
	if err != nil {
		return
	}

	var toCalc Calculation
	err = json.Unmarshal(bodyBytes, &toCalc)
	if err != nil {
		return
	}
	if toCalc.Calculation == "" {
		return
	}
	runner:=otto.New()
	result, err:= runner.Run(toCalc.Calculation)
	if err != nil {
		return
	}
	toCalc.Result, _= result.ToFloat()
	responseBytes, err := json.Marshal(toCalc)
	if err != nil {
		return
	}

	fmt.Fprint(response, string(responseBytes))
	return
}
