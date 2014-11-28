<p align="center">
  <img src="assets/images/Calculon.png" alt="Calculon" />
</p>
## Getting Started

You may start the server from the base directory with:
```
cd server
./server
```
The calculator will be served on "https://localhost:3000"

## Description of Server api
Server is built in go. It hosts a  rest api using the POST method at "https://localhost:3000/calculator".
Calculations run in a vm that performs the calculations and returns the result.

## Description of Client
Client uses Angular and Semantic UI. It was originally written in Coffeescript.

## Rebuild
To build or hack on to code with grunt and go installed:
```
npm install --save-dev
grunt
cd server
go build
```