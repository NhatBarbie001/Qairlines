package adapters

import (
	"context"

	"github.com/spaghetti-lover/qairlines/internal/domain/entities"
)

type ITicketRepository interface {
	GetTicketsByFlightID(ctx context.Context, flightID int64) ([]entities.Ticket, error)
	GetTicketByID(ctx context.Context, ticketID int64) (*entities.Ticket, error)
	CancelTicket(ctx context.Context, ticketID int64) (*entities.Ticket, error)
}
