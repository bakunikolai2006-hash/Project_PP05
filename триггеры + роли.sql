CREATE OR REPLACE FUNCTION sp_register_user(
    p_login VARCHAR(80),
    p_password_hash VARCHAR(64),
    p_full_name VARCHAR(150),
    p_email VARCHAR(150),
    p_role_id INT
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
     Проверка уникальности логина
    IF EXISTS (SELECT 1 FROM users WHERE login  p_login) THEN
        RAISE EXCEPTION 'Логин уже занят';
    END IF;
     Проверка уникальности email (если не NULL)
    IF p_email IS NOT NULL AND EXISTS (SELECT 1 FROM users WHERE email  p_email) THEN
        RAISE EXCEPTION 'Email уже зарегистрирован';
    END IF;
    
    INSERT INTO users (login, password_hash, full_name, email, role_id, is_active, created_at)
    VALUES (p_login, p_password_hash, p_full_name, p_email, p_role_id, TRUE, NOW());
END;
$$;



SELECT sp_register_user('master3', 'temp_hash', 'Дарья Козлова', 'darya@example.com', 2);


CREATE OR REPLACE FUNCTION fn_log_appointment_status_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO appointment_history (appointment_id, changed_by, old_status, new_status, note)
        VALUES (OLD.appointment_id, NULL, OLD.status, NEW.status, 'Автоматическая запись триггера');
    END IF;
    RETURN NEW;
END;
$$;


CREATE TRIGGER trg_log_status_change
AFTER UPDATE ON appointments
FOR EACH ROW
EXECUTE FUNCTION fn_log_appointment_status_change();


Проверка:  
 UPDATE appointments SET status  'выполнена' WHERE appointment_id  3; 

CREATE OR REPLACE FUNCTION fn_auto_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at  NOW();
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_auto_updated_at
BEFORE UPDATE ON appointments
FOR EACH ROW
EXECUTE FUNCTION fn_auto_updated_at();

Создание ролей (групп привилегий)
 
CREATE ROLE barbershop_readonly;
CREATE ROLE barbershop_master;
CREATE ROLE barbershop_admin;

 Права на подключение к базе и использование схемы public
GRANT CONNECT ON DATABASE "barbershop_Shejana" TO barbershop_readonly, barbershop_master, barbershop_admin;
GRANT USAGE ON SCHEMA public TO barbershop_readonly, barbershop_master, barbershop_admin;

 
 Привилегии: только чтение
 
GRANT SELECT ON ALL TABLES IN SCHEMA public TO barbershop_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO barbershop_readonly;

 
 Привилегии: мастер
 
GRANT SELECT, INSERT, UPDATE ON appointments, appointment_services, clients TO barbershop_master;
GRANT SELECT ON users, services, roles TO barbershop_master;
GRANT EXECUTE ON FUNCTION sp_change_appointment_status(INT, VARCHAR, INT, TEXT) TO barbershop_master;
GRANT EXECUTE ON FUNCTION sp_cancel_appointment(INT, INT, TEXT) TO barbershop_master;
GRANT USAGE ON SEQUENCE appointments_appointment_id_seq TO barbershop_master;
GRANT USAGE ON SEQUENCE appointment_services_appointment_service_id_seq TO barbershop_master;

 
 Привилегии: администратор
 
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO barbershop_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO barbershop_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO barbershop_admin;

 
 Создание учётных записей входа и назначение ролей
 
CREATE USER app_readonly WITH PASSWORD 'ReadOnly123';
GRANT barbershop_readonly TO app_readonly;

CREATE USER app_master WITH PASSWORD 'Master123';
GRANT barbershop_master TO app_master;

CREATE USER app_admin WITH PASSWORD 'Admin123';
GRANT barbershop_admin TO app_admin;
