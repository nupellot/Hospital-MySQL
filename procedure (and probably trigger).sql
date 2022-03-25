# Триггеры и процедуры. 
# Разработайте процедуру, которая сформирует и сохранит в отдельной таблице БД отчет по форме: 
# Год 
# Месяц 
# № врача 
# Фамилия врача 
# Количество пациентов врача за этот период.
# В отчет выбираются все врачи, которые были назначены лечащими для пациентов, поступивших в госпиталь в указанный период 
# Отчет составляется для периода, год и месяц которого передаются в процедуру в качестве входных параметров.
call createRaport(2022, 03);
select * from raport;
select * from story;
delete from story where id_story = 9;
insert into story(id_story, diagnosis, reg_date, discharge_date, story_doctor, story_ward, story_patient)
values(9, "ZPPP", "2022-03-22", null, 4, 2, 10);
drop trigger trigg;
SET SQL_SAFE_UPDATES = 0;
delete from raport;
select * from raport;
show tables;
use scheme_1;
drop procedure createRaport;
CREATE TABLE IF NOT EXISTS raport(
			id_doctor INT,
            raport_year INT,
            raport_month INT,
            doctor_surname VARCHAR(50),
            patients_amount INT);
delimiter //
create procedure createRaport(y int, m int)
	begin         

		declare doctor_id int;
		declare doctor_surname varchar(25);
		declare patient_amount int;
        declare done INT DEFAULT false;
        DECLARE raport_cursor CURSOR FOR
			SELECT doctor.id_doctor, doctor.inits, count(story.id_story)
			FROM doctor INNER JOIN story ON doctor.id_doctor = story.story_doctor
			WHERE YEAR(story.reg_date) = y AND MONTH(story.reg_date) = m
			GROUP BY doctor.id_doctor;
        
        declare exit handler for sqlstate '02000' begin set done = true; end;
		
        delete from raport;
		
        
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
        call createRaport(year(current_date()), month(current_date()));
    end;
\\

