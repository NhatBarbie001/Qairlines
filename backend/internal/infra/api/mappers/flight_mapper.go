package mappers

import (
	"strconv"

	"github.com/spaghetti-lover/qairlines/internal/domain/entities"
	"github.com/spaghetti-lover/qairlines/internal/infra/api/dto"
)

func CreateFlightRequestToEntity(req dto.CreateFlightRequest) entities.Flight {
	return entities.Flight{
		FlightID:         req.FlightID,
		FlightNumber:     req.FlightNumber,
		AircraftType:     req.AircraftType,
		DepartureCity:    req.DepartureCity,
		ArrivalCity:      req.ArrivalCity,
		DepartureAirport: req.DepartureAirport,
		ArrivalAirport:   req.ArrivalAirport,
		DepartureTime:    req.DepartureTime,
		ArrivalTime:      req.ArrivalTime,
		BasePrice:        req.BasePrice,
		Status:           req.Status,
	}
}

func CreateFlightEntityToResponse(flight entities.Flight) dto.CreateFlightResponse {
	return dto.CreateFlightResponse{
		Message: "Flight created successfully.",
		Flight: struct {
			FlightID         string `json:"flightId"`
			FlightNumber     string `json:"flightNumber"`
			AircraftType     string `json:"aircraftType"`
			DepartureCity    string `json:"departureCity"`
			ArrivalCity      string `json:"arrivalCity"`
			DepartureAirport string `json:"departureAirport"`
			ArrivalAirport   string `json:"arrivalAirport"`
			DepartureTime    string `json:"departureTime"`
			ArrivalTime      string `json:"arrivalTime"`
			BasePrice        int32  `json:"basePrice"`
			Status           string `json:"status"`
		}{
			FlightID:         strconv.FormatInt(flight.FlightID, 10),
			FlightNumber:     flight.FlightNumber,
			AircraftType:     flight.AircraftType,
			DepartureCity:    flight.DepartureCity,
			ArrivalCity:      flight.ArrivalCity,
			DepartureAirport: flight.DepartureAirport,
			ArrivalAirport:   flight.ArrivalAirport,
			DepartureTime:    flight.DepartureTime.String(),
			ArrivalTime:      flight.ArrivalTime.String(),
			BasePrice:        flight.BasePrice,
			Status:           string(flight.Status),
		},
	}
}
