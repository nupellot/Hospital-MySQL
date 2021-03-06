# База данных для организации работы госпиталя

Госпиталь состоит из отделений. Известно сколько палат в каждом отделении, этаж, где оно расположено, фамилия заведующего.
В каждом отделении работают врачи. При этом каждый врач по основной специальности работает только в одном отделении.
Каждому врачу присвоен уникальный номер, известны его фамилия, паспортные данные, адрес, год рождения, специализация, дата
поступления на работу в госпиталь. При увольнении врача проставляется также дата его увольнения.
В каждом отделении находится несколько палат. Каждая палата имеет номер, тип (обычная, реанимационная, УТР) и характеризуется
количеством мест.
При поступлении пациента в госпиталь его направляют в конкретное отделение и определенную палату. О каждом пациенте известны
его паспортные данные, адрес, дата рождения. Каждому пациенту при поступлении назначается один лечащий врач из числа врачей
отделения. Но каждый лечащий врач может вести нескольких пациентов.
На каждого больного ведется история болезни. История болезни открывается при поступлении пациента в госпиталь и закрывается при
выписке пациента, т.е. известны даты поступления и выписки пациента Если пациент поступает в госпиталь повторно, то на него
открывается новая история болезни.
Каждая история болезни имеет уникальный номер, в нее при поступлении заносится основный диагноз, дата поступления пациента и в
дальнейшем дата выписки из госпиталя.
Для консультаций пациентов в случае необходимости могут приглашаться врачи из других отделений.
Кажлый осмотр пациента врачом заканчивается записью в истории болезни. 
Каждая запись содержит сведения о враче, сделавшим запись, дату, основные наблюдения и назначения, сделанные в результате осмотра.
Вариант 5. Госпиталь.

## Инфологическая модель

![image](https://user-images.githubusercontent.com/54524404/174506977-42b5ac2a-0455-4d2c-be29-5107bebc6991.png)


## Простые запросы.
1. Показать все сведенья о врачах, принятых на работу в ‘апреле 2013 года.
Показать все сведенья о пациентах, выписавшихся из госпиталя в за последние 20 дней.
Показать, сколькими палатами каждой категории располагает каждое отделение госпиталя.
Показать средний возраст пациентов каждого отделения.
Показать, сколько пациентов из Москвы находится в настоящий момент в госпитале.
Показать, сколько записей в истории болезней сделал каждый приглашенный консультант в 2020 году.


## Сложные запросы
1. — Создать отчет о лечащих врачах отделения ХХХ за 2020 год по форме:
Уникальный номер врача, Фамилия врача, количество пациентов, у которых врач был лечащим.

2. — Составьте отчет об отделениях госпиталя по форме: Номер отделения, название отделения, Ф.И.О. заведующего,
количество мест в отделении.

3. — Покажите все сведенья о действующем враче, проработавшем в госпитале дольше всех.

4. — Показать все сведенья о врачах, которые ни разу не назначались лечащими врачами у пациентов (с помощью левостороннего соединения)

5. — Показать фамилии врачей, которые не назначались лечащими врачами пациентов в марте 2020 года.

6. — Показать все сведенья о враче, у который был назначен лечащим у наибольшего числа пациентов (с использованием View)


## Триггеры и процедуры.
Разработайте процедуру, которая сформирует и сохранит в отдельной таблице БД отчет по форме:
Год
Месяц
№ врача
Фамилия врача
количество пациентов врача за этот период.

В отчет выбираются все врачи, которые были назначены лечащими для пациентов, поступивших в госпиталь в указанный период
Отчет составляется для периода, год и месяц которого передаются в процедуру в качестве входных параметров.

Разработайте триггер, который будет срабатывать при добавлении новой записи о пациенте. В триггере реализовать увеличение
количества пациентов для соответствующего врача за текущий период.
