-- name: CreateUser :one
INSERT INTO "user" (
  first_name,
  last_name,
  hashed_password,
  email
) VALUES (
  $1, $2, $3, $4
) RETURNING *;

-- name: CreateAdmin :one
INSERT INTO "user" (
  first_name,
  last_name,
  hashed_password,
  role,
  email
) VALUES (
  $1, $2, $3, $4, $5
) RETURNING *;

-- name: GetUser :one
SELECT * FROM "user"
WHERE user_id = $1 LIMIT 1;

-- name: GetAllUser :many
SELECT * FROM "user";

-- name: ListUsers :many
SELECT * FROM "user"
ORDER BY user_id
LIMIT $1
OFFSET $2;

-- name: GetUserByEmail :one
SELECT * FROM "user"
WHERE email = $1 LIMIT 1;


-- name: DeleteUser :exec
DELETE FROM "user"
WHERE user_id = $1;

-- name: UpdatePassword :exec
UPDATE "user"
SET hashed_password = $2
WHERE user_id = $1;