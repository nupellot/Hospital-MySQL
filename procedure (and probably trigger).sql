# Триггеры и процедуры. 
# Разработайте процедуру, которая сформирует и сохранит в отдельной таблице БД отчет по форме: 
# Год 
# Месяц 
# № врача 
# Фамилия врача 
# Количество пациентов врача за этот период.
# В отчет выбираются все врачи, которые были назначены лечащими для пациентов, поступивших в госпиталь в указанный период 
# Отчет составляется для периода, год и месяц которого передаются в процедуру в качестве входных параметров.
use scheme_1;

# Тест процедуры
DROP PROCEDURE createRaport;  # Удаляем уже созданную старую версию процедуры.
# Идём куда-то вниз и вызываем создание новой версии процедуры.
CALL createRaport(2021, 04);  # Вызываем процедуру.
SELECT * FROM raport;  # Смотрим на результат её выполнения.

# Тест триггера
DROP TRIGGER Trigg;  # Удаляем уже созданную старую версию триггера.
# Идём куда-то вниз и вызываем создание новой версии триггера.
delete from raport;


# SET SQL_SAFE_UPDATES = 0;
# Создаём таблицу, в которой будет находиться отчёт
CREATE TABLE IF NOT EXISTS raport(
			id_doctor INT,
            raport_year INT,
            raport_month INT,
            doctor_surname VARCHAR(50),
            patients_amount INT);

# Определяем процедуру создания отчёта.
delimiter //
CREATE PROCEDURE createRaport(y INT, m INT)
	BEGIN
		# Переменные, через которые данные будут переданы из курсора в таблицу отчёта.
		DECLARE doctor_id INT;
		DECLARE doctor_surname VARCHAR(25);
		DECLARE patient_amount INT;
        DECLARE done INT DEFAULT FALSE;
        # Определяем формат курсора (таблицы с данными, по которой можно перемещаться только вниз).
        DECLARE raport_cursor CURSOR FOR
			SELECT doctor.id_doctor, doctor.inits, count(story.id_story)
			FROM doctor INNER JOIN story ON doctor.id_doctor = story.story_doctor
			WHERE YEAR(story.reg_date) = y AND MONTH(story.reg_date) = m
			GROUP BY doctor.id_doctor;
        
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN SET done = TRUE; END;
       /* DELETE FROM raport;*/
        OPEN raport_cursor;
        
        WHILE (done <> true) do
			FETCH NEXT FROM raport_cursor INTO doctor_id, doctor_surname, patient_amount;
            INSERT INTO raport(id_doctor, raport_year, raport_month, doctor_surname, patients_amount)
            VALUES(doctor_id, y, m, doctor_surname, patient_amount);
			END WHILE;
		close raport_cursor;


	END //

delimiter \\    
create trigger trigg AFTER INSERT ON story
for each row
	begin  
		# Если появилась новая история болезни, то нужно проверить, не было ли в этом месяце уже записи об этом враче.
        # Если запись была, то обновить её.
        # Если записи не было, то вставить новую.
        DECLARE ready INT DEFAULT 0;  # Переменная, показывающая, имеется ли в таблице нужная запись.
        SELECT count(*)
        FROM raport
        WHERE id_doctor = new.story_doctor AND raport_month = MONTH(new.reg_date) AND raport_year = YEAR(new.reg_date)
        INTO ready;
        
		IF ready = 0  # Если это первый случай попадания пациента к этому доктору в этот месяц этого года.
		then
			INSERT INTO raport(id_doctor, raport_year, raport_month, doctor_surname, patients_amount)
            VALUES(new.story_doctor, YEAR(new.reg_date), MONTH(new.reg_date), (SELECT surname FROM doctor), 1);
		end if;
        
		IF ready = 1  # Если уже был случай попадания пациенту к этому доктору в этот месяц этого года.
		then
			UPDATE raport
			SET patient_amount = patient_amount + 1
			WHERE id_doctor = new.story_doctor AND raport_month = MONTH(new.reg_date) AND raport_year = YEAR(new.reg_date);
		end if;
    end;
\\

drop trigger trigg;