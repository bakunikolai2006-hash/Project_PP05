CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

 Таблица 2: users
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    login VARCHAR(80) NOT NULL UNIQUE,
    password_hash VARCHAR(64) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE,
    role_id INT NOT NULL REFERENCES roles(role_id) ON DELETE RESTRICT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

 Таблица 3: clients
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(150) UNIQUE,
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

 Таблица 4: services
CREATE TABLE services (
    service_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    duration_minutes INT NOT NULL
);

 Таблица 5: appointments
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id) ON DELETE RESTRICT,
    master_id INT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    appointment_time TIMESTAMP NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'запланирована',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP
);

 Таблица 6: appointment_services
CREATE TABLE appointment_services (
    appointment_service_id SERIAL PRIMARY KEY,
    appointment_id INT NOT NULL REFERENCES appointments(appointment_id) ON DELETE CASCADE,
    service_id INT NOT NULL REFERENCES services(service_id) ON DELETE RESTRICT,
    quantity INT NOT NULL DEFAULT 1,
    price_at_time DECIMAL(10,2),
    UNIQUE (appointment_id, service_id)
);
