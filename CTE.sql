-- CTE => common table Expression
-- It work place of subquery, subquery work same as CTE there no deffernce in optimised, performance ect.
-- it's only improve readbility, and this is easy to debug when query is complex

-- Syntax --
WITH varibale_name AS (
    -- SQL query
)

-- get exam attempts that scored above class average
SELECT 
s.name as student_name,
s.branch as student_branch,
e.score
FROM exam_scores as e
INNER JOIN students as s ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) as class_average
    FROM exam_scores
);

-- by using CTE

WITH avg_cls AS(
    SELECT AVG(score) as class_average
    FROM exam_scores
)
SELECT 
s.name as student_name,
s.branch as student_branch,
e.score,
ca.class_average
FROM exam_scores as e
INNER JOIN students as s ON s.student_id = e.student_id
CROSS JOIN avg_cls as ca
WHERE e.score > ca.class_average;

-- when we need writh more than one CTE then simple write with a seperate comma(,)

WITH exam_toppers AS(
    SELECT DISTINCT student_id
    FROM exam_scores
    WHERE score > 90
),
project_toppers AS(
    SELECT DISTINCT student_id
    FROM projects
    WHERE marks > 85
)
SELECT
s.student_id,
s.name,
s.branch
FROM students as s
INNER JOIN exam_toppers AS et ON et.student_id = s.student_id
INNER JOIN projects AS pt ON pt.student_id = s.student_id;
