use scheme_1;

# 1. Создать отчёт о лечащих врачах отделения XXX за 2020 год по форме: Уникальный номер врача, Фамилия врача, количество пациентов, у которых врач был лечащим. 
SELECT 
	id_doctor, 
	inits, 
	surname, 
	count(id_story) AS 'AMOUNT OF PATIENTS' 
FROM 
	department 
	JOIN doctor ON id_department = doctors_department 
	JOIN story ON id_doctor = story_doctor
WHERE 
	department.department_name = 'Травмпункт' 
	AND (year(reg_date) = 2020 OR year(discharge_date) = 2020)
GROUP BY id_doctor;


# 2. Составте отчет об отделениях госпиталя по форме: Номер отделения, название отделения, фИО заведующего, количество мест в отделении.
SELECT 
	id_department, 
	department_name, 
	head_inits, 
	sum(capacity)
FROM 
	department 
	JOIN ward ON wards_department = id_department
GROUP BY id_department;


# 3. Покажите все сведения о действующем враче, проработавшем в госпитале дольше всех.
SELECT 
	doctor.*, 
	DATEDIFF(current_date(), recruitment_date) AS 'Проработал дней'
FROM doctor
WHERE dismissal_date IS NULL
ORDER BY DATEDIFF(current_date(), recruitment_date) DESC
LIMIT 1;

# 3.1. Более корректный вариант (Учитывает тот факт, что несколько врачей могли проработать равное количество времени)
SELECT 
	doctor.*, 
	DATEDIFF(current_date(), recruitment_date) AS 'Проработал дней'
FROM doctor
WHERE recruitment_date = (SELECT MIN(recruitment_date) FROM doctor WHERE dismissal_date IS NULL);


# 4. Показать все сведения о врачах, которые ни разу не назначались лечащими врачами у пациентов.
SELECT doctor.*
FROM 
	doctor 
	LEFT JOIN story ON story.story_doctor = doctor.id_doctor
WHERE id_story IS NULL;


# 5. Показать фамилии врачей, которые не назначались лечащими врачами пациентов в марте 2020 года.
# Создадим View, который посчитает число пациентов, принятых определенным врачём в период марта 2020 года.
CREATE VIEW report AS (
	SELECT 
		id_doctor, 
		count(id_story) AS amount
	FROM 
		doctor 
		INNER JOIN story ON story_doctor = id_doctor
	WHERE 
		YEAR(reg_date) = 2020 
		AND MONTH(reg_date) = 3
	GROUP BY id_doctor
);
# Теперь достаём тех докторов, которые не появились во View.
SELECT 
	id_doctor, 
	surname
FROM 
	doctor 
	LEFT JOIN report USING (id_doctor)
WHERE amount IS NULL;
# Для отладки.
DROP VIEW report;
SELECT * FROM report;


# 6. Показать все сведения о враче, который был назначен лечащим у наибольшего числа пациентов (с использование View)
drop view Imya;
select * from Imya;
CREATE VIEW Imya AS (
SELECT 
	doctor.*, 
	count(id_story) as quantity
FROM 
	doctor 
	JOIN story ON story_doctor = id_doctor
GROUP BY doctor.id_doctor
ORDER BY count(id_story) DESC
);

SELECT * FROM Imya
WHERE quantity = (SELECT max(quantity) FROM Imya);
