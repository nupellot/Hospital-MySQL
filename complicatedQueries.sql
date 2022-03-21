# 1. Создать отчёт о лечащих врачах отделения XXX за 2020 год по форме: Уникальный номер врача, Фамилия врача, количество пациентов, у которых врач был лечащим. 
SELECT id_doctor, inits, count(id_story) FROM doctor JOIN story ON id_doctor = story_doctor
WHERE doctors_department = 1 AND (year(reg_date) = 2020 OR year(discharge_date) = 2020)
GROUP BY id_story;


# 2. Составте отчет об отделениях госпиталя по форме: Номер отделения, название отделения, фИО заведующего, количество мест в отделении.
SELECT id_department, department_name, head_inits, sum(capacity)
FROM department JOIN ward ON wards_department = id_department
GROUP BY id_ward;


# 3. Покажите все сведения о действующем враче, проработавшем в госпитале дольше всех.
SELECT id_doctor, recruitment_date, current_date() - recruitment_date
FROM doctor
WHERE dismissal_date IS NULL
ORDER BY current_date() - recruitment_date DESC
LIMIT 1;

SELECT id_doctor, current_date() - recruitment_date  # НЕ РАБОТАЕТ
FROM doctor
WHERE dismissal_date IS NULL AND (current_date() - recruitment_date = (SELECT MAX(current_date() - recruitment_date) FROM doctor));


# 4. Показать все сведения о врачах, которые ни разу не назначались лечащими врачами у пациентов.
SELECT doctor.*
FROM doctor LEFT JOIN story ON story_doctor = id_doctor
WHERE id_story IS NULL;


# 5. Показать фамилии врачей, которые не назначались лечащими врачами пациентов в марте 2020 года.
SELECT doctor.*
FROM doctor JOIN story ON story_doctor = id_doctor
WHERE NOT (YEAR(reg_date) = 2020 AND MONTH(reg_date) = 3);


# 6. Показать все сведения о враче, который был назначен лечащим у наибольшего числа пациентов (с использование View)
drop view Imya;
select * from Imya;
CREATE VIEW Imya AS (
	SELECT doctor.*, count(id_story) as quantity
    FROM doctor JOIN story ON story_doctor = id_doctor
    GROUP BY doctor.id_doctor
    ORDER BY count(id_story));

SELECT * FROM Imya
WHERE quantity = (SELECT max(quantity) FROM Imya);
