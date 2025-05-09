CREATE TABLE "airport" (
  "airport_id" bigserial PRIMARY KEY,
  "airport_code" varchar NOT NULL,
  "city" varchar NOT NULL,
  "name" varchar NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "airplane_model" (
  "airplane_model_id" bigserial PRIMARY KEY,
  "name" varchar NOT NULL,
  "manufacturer" varchar NOT NULL,
  "total_seats" bigint NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "airplane" (
  "airplane_id" bigserial PRIMARY KEY,
  "airplane_model_id" bigint NOT NULL,
  "registration_number" varchar UNIQUE NOT NULL,
  "active" boolean DEFAULT true
);

CREATE TYPE flight_status AS ENUM ('Landed', 'Delayed', 'On Time', 'Scheduled');

CREATE TABLE "flight" (
  "flight_id" bigserial PRIMARY KEY,
  "flight_number" varchar UNIQUE NOT NULL,
  "registration_number" varchar UNIQUE NOT NULL,
  "estimated_departure_time" timestamp NOT NULL,
  "actual_departure_time" timestamp,
  "estimated_arrival_time" timestamp NOT NULl,
  "actual_arrival_time" timestamp,
  "departure_airport_id" bigint NOT NULL,
  "destination_airport_id" bigint NOT NULL,
  "flight_price" NUMERIC(12,2) NOT NULL CHECK(flight_price >= 0),
  "status" flight_status NOT NULL
);

CREATE TABLE "flight_seats" (
  "flight_seats_id" bigserial PRIMARY KEY,
  "registration_number" varchar UNIQUE NOT NULL,
  "flight_class" varchar NOT NULL,
  "class_multiplier" NUMERIC(12,2),
  "child_multiplier" NUMERIC(12,2),
  "max_row_seat" bigint NOT NULL,
  "max_col_seat" bigint NOT NULL
);

CREATE TYPE flight_class_type AS ENUM ('Economy', 'Business', 'First');

CREATE TABLE "booking" (
  "booking_id" varchar PRIMARY KEY,
  "booker_email" varchar NOT NULL,
  "number_of_adults" bigint NOT NULL,
  "number_of_children" bigint NOT NULL,
  "flight_class" flight_class_type NOT NULL,
  "cancelled" BOOLEAN DEFAULT false,
  "flight_id" bigint NOT NULL,
  "booking_date" timestamp DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "passengers" (
  "passenger_id" bigserial PRIMARY KEY,
  "booking_id" varchar NOT NULL,
  "citizen_id" varchar NOT NULL,
  "passport_number" varchar,
  "gender" varchar(10) NOT NULL,
  "phone_number" varchar NOT NULL,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "nationality" varchar NOT NULL,
  "date_of_birth" date NOT NULL,
  "seat_row" int NOT NULL,
  "seat_col" varchar(2) NOT NULL
);

CREATE TABLE "payment" (
  "payment_id" bigserial PRIMARY KEY,
  "transaction_date_time" timestamp DEFAULT NOW() NOT NULL,
  "amount" NUMERIC(12,2),
  "currency" varchar DEFAULT 'USD',
  "payment_method" varchar,
  "status" varchar DEFAULT 'pending',
  "booking_id" varchar UNIQUE
);

COMMENT ON COLUMN "flight_seats"."max_row_seat" IS 'CHECK > 0';

COMMENT ON COLUMN "booking"."number_of_adults" IS 'CHECK > 0';

COMMENT ON COLUMN "booking"."number_of_children" IS 'CHECK (number_of_children >= 0)';

COMMENT ON COLUMN "passengers"."gender" IS 'CHECK (gender IN (''Male'', ''Female''))';

ALTER TABLE "airplane" ADD FOREIGN KEY ("airplane_model_id") REFERENCES "airplane_model" ("airplane_model_id") ON DELETE CASCADE;

ALTER TABLE "flight" ADD FOREIGN KEY ("registration_number") REFERENCES "airplane" ("registration_number") ON DELETE CASCADE;

ALTER TABLE "flight" ADD FOREIGN KEY ("departure_airport_id") REFERENCES "airport" ("airport_id") ON DELETE CASCADE;

ALTER TABLE "flight" ADD FOREIGN KEY ("destination_airport_id") REFERENCES "airport" ("airport_id") ON DELETE CASCADE;

ALTER TABLE "flight_seats" ADD FOREIGN KEY ("registration_number") REFERENCES "airplane" ("registration_number") ON DELETE CASCADE;

ALTER TABLE "booking" ADD FOREIGN KEY ("flight_id") REFERENCES "flight" ("flight_id") ON DELETE CASCADE;

ALTER TABLE "passengers" ADD FOREIGN KEY ("booking_id") REFERENCES "booking" ("booking_id") ON DELETE CASCADE;

ALTER TABLE "payment" ADD FOREIGN KEY ("booking_id") REFERENCES "booking" ("booking_id") ON DELETE CASCADE;