# Простые запросы
USE scheme_1;
show tables;

SELECT * FROM doctor;
/* 1. Показать все сведения о врачах, принятых на работу в апреле 2013 года */
SELECT * FROM doctor
WHERE year(recruitment_date) = 2013 AND month(recruitment_date) = 04;

/* 2. Показать все сведения о пациентах, выписавшихся из гостпиталя за последние 20 дней */
SELECT DISTINCT * FROM patient, story 
WHERE datediff(current_date(), story.discharge_date) <= 20 AND story.story_patient = patient.id_patient;

/* 3. Показать, сколькими палатами каждой категории располагает каждое отделение госпиталя */
SELECT wards_department, wtype, count(wtype) FROM ward 
GROUP BY wards_department, wtype;

/* 4. Показать средний возраст пациентов каждого отделения */
SELECT id_department, (sum(datediff(current_date(), patient.birth_date))/count(patient.birth_date))/365 AS average FROM department, ward, story, patient 
WHERE (id_department = wards_department) AND (id_ward = story_ward) AND (id_patient = story_patient) 
GROUP BY id_department;

/* 5. Показать, сколько пациентов из Москвы находится в данный момент в госпитале */
SELECT count(id_patient) FROM patient, story 
WHERE patient.id_patient = story.story_patient 
AND address = 'Москва'
AND discharge_date IS NULL;

/* 6. Показать, сколько записей в истории болезней сделал каждый приглашенный консультант в 2020 году */
SELECT id_doctor, count(id_survey) AS amount FROM doctor, survey 
WHERE (doctor.id_doctor = survey.survey_doctor) GROUP BY id_doctor;