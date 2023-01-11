CREATE VIEW lessons_per_month AS
SELECT
    EXTRACT(MONTH FROM start_time) AS month,
		COUNT(*) AS total_number_of_lessons,
		SUM(CASE WHEN lesson_type='individual' THEN 1 ELSE 0 END) AS number_of_individual_lessons,
		SUM(CASE WHEN lesson_type='group' THEN 1 ELSE 0 END) AS number_of_group_lessons,
		SUM(CASE WHEN lesson_type='ensemble' THEN 1 ELSE 0 END) AS number_of_ensembles
	FROM (SELECT * FROM lesson WHERE EXTRACT(YEAR FROM start_time)='2022') as lessons_specified_year
	GROUP BY month

CREATE VIEW number_of_students_with_siblings
SELECT 
	SUM(CASE WHEN count='1' THEN 1 ELSE 0 END) AS students_with_no_siblings,
	SUM(CASE WHEN count='2' THEN 2 ELSE 0 END) AS students_with_one_sibling,
	SUM(CASE WHEN count='3' THEN 3 ELSE 0 END) AS students_with_two_siblings,
	SUM(CASE WHEN count='4' THEN 4 ELSE 0 END) AS students_with_three_siblings
FROM (SELECT COUNT(sibling_group_id)
FROM student
GROUP BY sibling_group_id) AS sibling_group_counts

CREATE VIEW instructors_with_many_lessons AS
SELECT instructor_id, COUNT(*) AS given_lessons
FROM 
    (SELECT * FROM lesson WHERE
    EXTRACT(YEAR FROM start_time)=EXTRACT(YEAR FROM CURRENT_DATE) AND
    EXTRACT(MONTH FROM start_time)=EXTRACT(MONTH FROM CURRENT_DATE) AND
    EXTRACT(DAY FROM start_time) < EXTRACT(DAY FROM CURRENT_DATE)) AS total_given_lessons_current_month
GROUP BY instructor_id HAVING COUNT(*) > 2
ORDER BY given_lessons DESC

CREATE MATERIALIZED VIEW
SELECT 
genre, 
to_char(start_time, 'DAY') as day_of_week, 
start_time::time as time,
CASE
	WHEN COUNT(id) = maximum_students THEN 'no spots'
	WHEN maximum_students - COUNT(id) = 1 THEN 'one spot left'
	WHEN maximum_students - COUNT(id) = 2 THEN 'two spots left'
	ELSE 'more than two spots left'
END as remaining_spots
FROM
((SELECT *
-- CHANGE THE TWO LINES BELOW TO THE TWO COMMENTED LINES BELOW TO GET SEEDED DATA AS OUTPUT AT A LATER TIME
FROM lesson WHERE DATE_PART('week', start_time) = DATE_PART('week', CURRENT_DATE) + 1
AND EXTRACT(YEAR FROM start_time) = EXTRACT(YEAR FROM CURRENT_DATE)
--FROM lesson WHERE DATE_PART('week', start_time) = 2
--AND EXTRACT(YEAR FROM start_time) = '2023'
AND lesson_type='ensemble') b
LEFT JOIN lesson_student ON b.id = lesson_student.lesson_id
) a
GROUP BY start_time, genre, maximum_students
ORDER BY genre, DATE_PART('day', start_time)

