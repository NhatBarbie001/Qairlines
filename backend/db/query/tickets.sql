-- name: CreateTicket :one
INSERT INTO tickets (
  flight_class,
  price,
  status,
  booking_id,
  flight_id
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetTicketByID :one
SELECT
    t.ticket_id,
    t.status,
    t.flight_class,
    t.price,
    t.booking_id,
    t.flight_id,
    t.created_at,
    t.updated_at,
    s.seat_code,
    o.first_name AS owner_first_name,
    o.last_name AS owner_last_name,
    o.gender AS owner_gender,
    o.phone_number AS owner_phone_number
FROM Tickets t
LEFT JOIN Seats s ON t.seat_id = s.seat_id
LEFT JOIN TicketOwnerSnapshot o ON t.ticket_id = o.ticket_id
WHERE t.ticket_id = $1;

-- name: ListTickets :many
SELECT * FROM tickets
ORDER BY ticket_id
LIMIT $1
OFFSET $2;

-- name: GetTicketByFlightId :many
SELECT * FROM tickets
WHERE flight_id = $1
ORDER BY ticket_id;

-- name: DeleteTicket :exec
DELETE FROM tickets
WHERE ticket_id = $1;

-- name: UpdateTicket :exec
UPDATE tickets
SET
  flight_class = $2,
  price = $3,
  status = $4,
  booking_id = $5,
  flight_id = $6,
  updated_at = NOW()
WHERE ticket_id = $1;

-- name: GetTicketsByFlightID :many
SELECT
    t.ticket_id,
    t.seat_id,
    t.flight_class,
    t.price,
    t.status,
    t.booking_id,
    t.flight_id,
    t.created_at,
    t.updated_at,
    s.seat_code,
    s.is_available,
    s.class AS seat_class,
    o.first_name AS owner_first_name,
    o.last_name AS owner_last_name,
    o.phone_number AS owner_phone_number,
    o.gender AS owner_gender
FROM Tickets t
LEFT JOIN Seats s ON t.seat_id = s.seat_id
LEFT JOIN TicketOwnerSnapshot o ON t.ticket_id = o.ticket_id
WHERE t.flight_id = $1;

-- name: UpdateTicketStatus :one
UPDATE Tickets
SET status = $2, updated_at = NOW()
WHERE ticket_id = $1
RETURNING *;

-- name: CancelTicket :one
UPDATE Tickets
SET status = 'cancelled', updated_at = NOW()
WHERE Tickets.ticket_id = $1 AND status = 'booked'
RETURNING ticket_id, status, flight_class, price, booking_id, flight_id, updated_at,
          (SELECT seat_code FROM Seats WHERE seat_id = Tickets.seat_id) AS seat_code,
          (SELECT first_name FROM TicketOwnerSnapshot WHERE ticket_id = Tickets.ticket_id) AS owner_first_name,
          (SELECT last_name FROM TicketOwnerSnapshot WHERE ticket_id = Tickets.ticket_id) AS owner_last_name,
          (SELECT phone_number FROM TicketOwnerSnapshot WHERE ticket_id = Tickets.ticket_id) AS owner_phone_number;
