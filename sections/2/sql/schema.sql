CREATE TABLE IF NOT EXISTS manufacturer(
    id SERIAL,
    name VARCHAR,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS car_model(
    id SERIAL,
    manufacturer_id INTEGER,
    model_name VARCHAR NOT NULL,
    weight DECIMAL,
    PRIMARY KEY (id),
    CONSTRAINT fk_manufacturer FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(id),
    CONSTRAINT uc_manufacturer_model UNIQUE (manufacturer_id, model_name)
);

CREATE TABLE IF NOT EXISTS car(
    id SERIAL,
    car_model_id INTEGER,
    serial_no VARCHAR NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_car_model FOREIGN KEY (car_model_id) REFERENCES car_model(id)
);

CREATE TABLE IF NOT EXISTS customer(
    id SERIAL,
    name VARCHAR NOT NULL,
    phone VARCHAR NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uc_phone UNIQUE (phone)
);

CREATE TABLE IF NOT EXISTS salesperson(
    id SERIAL,
    name VARCHAR,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS "transaction"(
    id SERIAL,
    car_id INTEGER,
    customer_id INTEGER,
    salesperson_id INTEGER,
    datetime TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_car FOREIGN KEY (car_id) REFERENCES car(id),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_salesperson FOREIGN KEY (salesperson_id) REFERENCES salesperson(id)
);