 Роли
INSERT INTO roles (role_name, description) VALUES
('admin', 'Администратор системы'),
('master', 'Мастер парикмахерской');

 Пользователи 
INSERT INTO users (login, password_hash, full_name, email, role_id, is_active) VALUES
('admin', 'temp_placeholder', 'Снежана Иванова', 'snezhana@example.com', 1, TRUE),
('master1', 'temp_placeholder', 'Ольга Петрова', 'olga@example.com', 2, TRUE),
('master2', 'temp_placeholder', 'Екатерина Смирнова', 'katya@example.com', 2, TRUE);

 Клиенты
INSERT INTO clients (full_name, phone, email) VALUES
('Анна Кузнецова', '79161234567', 'anna@mail.ru'),
('Мария Лебедева', '79261234568', 'maria@mail.ru'),
('Ирина Волкова', NULL, 'irina@mail.ru');

 Услуги
INSERT INTO services (name, description, price, duration_minutes) VALUES
('Стрижка женская', 'Мытьё, стрижка, укладка', 2000.00, 60),
('Окрашивание', 'Окрашивание корней или полностью', 4500.00, 120),
('Укладка', 'Вечерняя укладка с фиксацией', 1500.00, 40);

 Записи
INSERT INTO appointments (client_id, master_id, appointment_time, status, notes) VALUES
(1, 2, '20260513 10:00:00', 'запланирована', 'Просьба сделать покороче'),
(2, 2, '20260513 11:00:00', 'запланирована', NULL),
(3, 3, '20260513 12:00:00', 'запланирована', 'Только окрашивание');

 Связка записьуслуги
INSERT INTO appointment_services (appointment_id, service_id, quantity, price_at_time) VALUES
(1, 1, 1, 2000.00),
(1, 3, 1, 1500.00),   первая запись: стрижка  укладка
(2, 2, 1, 4500.00),
(3, 2, 1, 4500.00);

