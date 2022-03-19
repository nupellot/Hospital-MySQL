use scheme_1;
show tables;

select * from doctor;
/* Показать все сведения о врачах, принятых на работу в апреле 2013 года */
SELECT * FROM doctor WHERE year(recruitment_date) = 2013 and month(recruitment_date) = 04;
/* Показать все сведения о пациентах, выписавшихся из гостпиталя за последние 20 дней */
select distinct * from patient, story where datediff(current_date(), story.discharge_date) <= 20 and story.story_patient = patient.id_patient;

/* Показать, сколькими палатами каждой категории располагает каждое отделение госпиталя */
select wards_department, wtype, count(wtype) from ward group by wards_department, wtype;

/* Показать средний возраст пациентов каждого отделения */
select id_department, (sum(datediff(current_date(), patient.birth_date))/count(patient.birth_date)) as average from department, ward, story, patient where (id_department = wards_department) and (id_ward = story_ward) and (id_patient = story_patient) group by id_department;
select id_department, (sum(datediff(current_date(), patient.birth_date))/count(patient.birth_date))/365 as average from department, ward, story, patient where (id_department = wards_department) and (id_ward = story_ward) and (id_patient = story_patient) group by id_department;

/* Показать, сколько пациентов из Москвы находится в данный момент в госпитале */
select count(id_patient) from patient, story 
where patient.id_patient = story.story_patient 
and address = 'Москва'
and discharge_date IS NULL;

/* Показать, сколько записей в истории болезней сделал каждый приглашенный консультант в 2020 году */
select id_doctor, count(id_survey) as amount from doctor, survey 
where (doctor.id_doctor = survey.survey_doctor) group by id_doctor;