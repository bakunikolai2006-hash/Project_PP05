CREATE OR REPLACE FUNCTION sp_change_appointment_status(
    p_appointment_id INT,
    p_new_status VARCHAR(30),
    p_user_id INT,
    p_note TEXT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_status VARCHAR(30);
BEGIN
     Получить текущий статус
    SELECT status INTO v_old_status
    FROM appointments
    WHERE appointment_id  p_appointment_id;

     Обновить статус
    UPDATE appointments
    SET status  p_new_status,
        updated_at  NOW()
    WHERE appointment_id  p_appointment_id;

     Записать историю
    INSERT INTO appointment_history (appointment_id, changed_by, old_status, new_status, note)
    VALUES (p_appointment_id, p_user_id, v_old_status, p_new_status, p_note);
END;
$$;


Вызов:
SELECT sp_change_appointment_status(1, 'выполнена', 2, 'Клиент доволен');

CREATE OR REPLACE FUNCTION sp_cancel_appointment(
    p_appointment_id INT,
    p_user_id INT,
    p_note TEXT DEFAULT 'Отменена'
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
     Проверим, что запись существует и не отменена ранее
    IF NOT EXISTS (SELECT 1 FROM appointments WHERE appointment_id  p_appointment_id) THEN
        RAISE EXCEPTION 'Запись с ID % не найдена', p_appointment_id;
    END IF;
    
     Вызовем функцию смены статуса
    PERFORM sp_change_appointment_status(p_appointment_id, 'отменена', p_user_id, p_note);
END;
$$;


Вызов:
SELECT sp_cancel_appointment(2, 1, 'Клиент перезвонил и отказался');

