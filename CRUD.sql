-- INNER JOIN — записи с именами мастера и клиента
SELECT a.appointment_id, c.full_name AS client, u.full_name AS master,
       a.appointment_time, a.status
FROM appointments a
JOIN clients c ON a.client_id  c.client_id
JOIN users u ON a.master_id  u.user_id
ORDER BY a.appointment_time DESC;

-- INNER JOIN (3 таблицы) — полная информация о записях с услугами
SELECT a.appointment_id, c.full_name AS client, u.full_name AS master,
       a.appointment_time, a.status, s.name AS service, aps.quantity,
       COALESCE(aps.price_at_time, s.price) AS service_price
FROM appointments a
JOIN clients c ON a.client_id  c.client_id
JOIN users u ON a.master_id  u.user_id
JOIN appointment_services aps ON a.appointment_id  aps.appointment_id
JOIN services s ON aps.service_id  s.service_id
ORDER BY a.appointment_time;

-- LEFT JOIN — все клиенты, включая тех, у кого нет записей
SELECT c.client_id, c.full_name, c.phone, COUNT(a.appointment_id) AS appointments_count
FROM clients c
LEFT JOIN appointments a ON c.client_id  a.client_id
GROUP BY c.client_id
ORDER BY appointments_count;

--RIGHT JOIN — все услуги, включая те, которые не были назначены
SELECT s.service_id, s.name, COUNT(aps.appointment_service_id) AS usage_count
FROM appointment_services aps
RIGHT JOIN services s ON aps.service_id  s.service_id
GROUP BY s.service_id, s.name
ORDER BY usage_count DESC;

--Агрегат с GROUP BY  HAVING — мастера с более чем одной записью
SELECT u.full_name, COUNT(a.appointment_id) AS total_appointments
FROM users u
JOIN appointments a ON u.user_id  a.master_id
GROUP BY u.user_id, u.full_name
HAVING COUNT(a.appointment_id)  1
ORDER BY total_appointments DESC;


