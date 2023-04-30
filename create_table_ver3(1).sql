DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE "membership_status" (
  "royalty_level" VARCHAR(20),
  "discount" NUMERIC(4,2),
  PRIMARY KEY ("royalty_level")
);

CREATE TABLE "address" (
  "address_id" INTEGER,
  "street" VARCHAR(200),
  "city" VARCHAR(200),
  "state" VARCHAR(200),
  "country" VARCHAR(200),
  "zipcode" INTEGER,
  PRIMARY KEY ("address_id")
);

CREATE TABLE "customers" (
  "customer_id" INTEGER,
  "first_name" VARCHAR(20),
  "last_name" VARCHAR(20),
  "email" VARCHAR(50),
  "address_id" INTEGER,
  "royalty_points" INTEGER,
  "royalty_level" VARCHAR(20),
  PRIMARY KEY ("customer_id"),
  FOREIGN KEY ("address_id")
      REFERENCES "address"("address_id"),
  FOREIGN KEY ("royalty_level")
      REFERENCES "membership_status"("royalty_level")
);


CREATE TABLE "order_tracker" (
  "customer_id" INTEGER,
  "order_time" DATE,
  "order_id" INTEGER PRIMARY KEY,
  "royalty_point_reward" INTEGER,
  FOREIGN KEY ("customer_id")
      REFERENCES "customers"("customer_id")
);

CREATE TABLE "reservation_tracker" (
  "reservation_id" INTEGER PRIMARY KEY,
  "order_id" INTEGER,
  "reservation_type" VARCHAR(20),
  FOREIGN KEY ("order_id")
      REFERENCES "order_tracker"("order_id")
);

CREATE TABLE "hotels" (
  "hotel_id" INTEGER,
  "hotel_name" VARCHAR,
  "address_id" INTEGER,
  PRIMARY KEY ("hotel_id"),
  foreign key("address_id") references "address"("address_id")
);

CREATE TABLE "hotel_rooms" (
  "hotel_id" INTEGER,
  "room_number" INTEGER,
  "room_type_name" VARCHAR,
  "room_type_price" NUMERIC(10,2),
  "room_type_occupancy" INTEGER,
  "room_type_breakfast" VARCHAR,
  "room_type_cancellation" VARCHAR,
  PRIMARY KEY ("hotel_id", "room_number"),
  CONSTRAINT "FK_hotel_rooms.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id")
);

CREATE TABLE "hotel_reservations" (
  "reservation_id" INTEGER,
  "hotel_id" INTEGER,
  "room_number" INTEGER,
  "arrival_date" date,
  "departure_date" date,
  "car_parking_needed" INTEGER,
  "price" NUMERIC,
  CONSTRAINT "FK_hotel_reservations.reservation_id"
    FOREIGN KEY ("reservation_id")
      REFERENCES "reservation_tracker"("reservation_id"),
  CONSTRAINT "FK_hotel_reservations.hotel_id"
    FOREIGN KEY ("hotel_id")
      REFERENCES "hotels"("hotel_id")
);


CREATE TABLE "airports" (
  "airport_id" INTEGER,
  "name" VARCHAR(200),
  "country" VARCHAR,
  "IATA" VARCHAR(200),
  "ICAO" VARCHAR(200),
  "timezone" VARCHAR,
  "address_id" INTEGER,
  PRIMARY KEY ("airport_id"),
  CONSTRAINT "FK_airports.address_id"
    FOREIGN KEY ("address_id")
      REFERENCES "address"("address_id")
);

CREATE TABLE "airline" (
  "id" INTEGER,
  "name" VARCHAR(200),
  "alias" VARCHAR(200),
  "IATA" VARCHAR(200),
  "ICAO" VARCHAR(200),
  PRIMARY KEY ("id")
);

CREATE TABLE "airplanes" (
  "airplane_id" INTEGER,
  "airplane_name" VARCHAR(200),
  "IATA" VARCHAR(200),
  "ICAO" VARCHAR(200),
  PRIMARY KEY ("airplane_id")
);

CREATE TABLE "flight_routes" (
  "flight_route_id" INTEGER,
  "origin" INTEGER,
  "destination" INTEGER,
  "stop" INTEGER,
  "airline_id" INTEGER,
  "airplane_id" INTEGER,
  PRIMARY KEY ("flight_route_id"),
  CONSTRAINT "FK_flight_routes.origin"
    FOREIGN KEY ("origin")
      REFERENCES "airports"("airport_id"),
  CONSTRAINT "FK_flight_routes.destination"
    FOREIGN KEY ("destination")
      REFERENCES "airports"("airport_id"),
  CONSTRAINT "FK_flight_routes.airline_id"
    FOREIGN KEY ("airline_id")
      REFERENCES "airline"("id"),
  CONSTRAINT "FK_flight_routes.airplane_id"
    FOREIGN KEY ("airplane_id")
      REFERENCES "airplanes"("airplane_id")
);

CREATE TABLE "flight_info" (
  "flight_info_id" INTEGER,
  "flight_route_id" INTEGER,	
  "dep_time" TIMESTAMP,
  "arr_time" TIMESTAMP,
  "delayed"  INT,
  "time_hour" INTEGER,
  PRIMARY KEY ("flight_info_id"),
  CONSTRAINT "FK_flight_info.flight_route_id"
    FOREIGN KEY ("flight_route_id")
      REFERENCES "flight_routes"("flight_route_id")
);


CREATE TABLE "flight_reservation" (
  "reservation_id" INTEGER,
  "flight_status" INTEGER,
  "class" VARCHAR(20),
  "seat" VARCHAR(20),
  "price" NUMERIC,
  "flight_info_id" INTEGER,
  CONSTRAINT "FK_flight_reservation.reservation_id"
    FOREIGN KEY ("reservation_id")
      REFERENCES "reservation_tracker"("reservation_id"),
  CONSTRAINT "FK_flight_reservation.flight_info_id"
    FOREIGN KEY ("flight_info_id")
      REFERENCES "flight_info"("flight_info_id")
);

CREATE TABLE "cars" (
  "car_brand" VARCHAR(200),
  "car_model" VARCHAR(200),
  "car_type" VARCHAR(200),
  "fuel_type" VARCHAR(200),
  "car_year" INTEGER,
  "owner_id" VARCHAR(200),
  "color" VARCHAR(200),
  "plate_number" VARCHAR(200),
  PRIMARY KEY ("plate_number")
);

CREATE TABLE "car_reservations" (
  "reservation_id" INTEGER,
  "plate_number" VARCHAR(200),
  "pick_up_date" DATE,
  "pick_up_location" INTEGER,
  "drop_date" DATE,
  "drop_location" INTEGER,
  "price" NUMERIC,
  CONSTRAINT "FK_car_reservations.reservation_id"
    FOREIGN KEY ("reservation_id")
      REFERENCES "reservation_tracker"("reservation_id"),
  CONSTRAINT "FK_car_reservations.plate_number"
    FOREIGN KEY ("plate_number")
      REFERENCES "cars"("plate_number"),
  CONSTRAINT "FK_car_reservations.pick_up_location"
    FOREIGN KEY ("pick_up_location")
      REFERENCES "address"("address_id"),
  CONSTRAINT "FK_car_reservations.drop_location"
    FOREIGN KEY ("drop_location")
      REFERENCES "address"("address_id")
);

