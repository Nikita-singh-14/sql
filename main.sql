CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    branch VARCHAR(50) NOT NULL
);
CREATE TABLE exam_scores (
    score_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    subject VARCHAR(30) NOT NULL,
    score INT NOT NULL CHECK (
        score BETWEEN 0 AND 100
    ),
    exam_month VARCHAR(7) NOT NULL
);
CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY,
    student_id INT NOT NULL REFERENCES students(student_id),
    title VARCHAR(80) NOT NULL,
    marks INT NOT NULL CHECK (
        marks BETWEEN 0 AND 100
    )
) ;
INSERT INTO students (name, branch) VALUES
('Rahul', 'CS'),
('Sneha', 'CS'),
('Amit', 'IT'),
('Priya', 'IT'),
('Rohan', 'CS'),
('Kavya', 'IT'),
('Arjun', 'CS'),
('Divya', 'IT');
INSERT INTO exam_scores (student_id, subject, score, exam_month) VALUES
(1, 'Math', 62, '2024-07'),
(1, 'SQL', 70, '2024-08'),
(1, 'Math', 72, '2024-09'),
(1, 'SQL', 88, '2024-10'),
(1, 'English', 65, '2024-07'),
(2, 'Math', 88, '2024-08'),
(2, 'SQL', 92, '2024-09'),
(2, 'Math', 91, '2024-09'),
(2, 'SQL', 95, '2024-10'),
(2, 'English', 78, '2024-07'),
(3, 'Math', 48, '2024-08'),
(3, 'SQL', 55, '2024-07'),
(4, 'Math', 48, '2024-08'),
(4, 'SQL', 55, '2024-07'),
(4, 'SQL', 48, '2024-08'),
(4, 'English', 55, '2024-07'),
(6, 'Math', 48, '2024-08'),
(6, 'SQL', 55, '2024-07'),
(7, 'Math', 48, '2024-08'),
(7, 'SQL', 55, '2024-07'),
(8, 'Math', 68, '2024-09'),
(8, 'English', 72, '2024-10');
INSERT INTO projects (student_id, title, marks) VALUES
(1, 'Todo App in React', 78),
(2, 'E-commerce API', 96),
(3, 'Attendence Tracker', 72),
(4, 'Portfolio Website', 88),
(5, 'Blog CMS', 81),
(6, 'Chat App with WebSockets', 90);
-- Subquery --
-- 1) Get exam attempts that scored above average
-- calculate avg that sum of all scores divide by total number of rows
SELECT AVG(score) as class_average 
FROM exam_scores;
SELECT 
s.name as student_name,
s.branch as student_branch,
e.score
 FROm exam_scores as e 
INNER JOIN students as s ON s.student_id = e.student_id
-- here we have must be to return single column
WHERE e.score > (
    SELECT AVG(score) as class_average
    FROM exam_scores
);
-- ! Criteria for placement
-- 1. At least 1 exam attempt have score >= 90
-- * AND
-- 2. Any one of their projects should have marks >= 85
SELECT * from exam_scores as e WHERE e.score >= 90;
SELECT * from projects as p WHERE p.marks >= 85;
SELECT 
s.student_id,
s.name as student_name,
s.branch as student_branch
FROM 
students as s
WHERE s.student_id IN (
    SELECT student_id from exam_scores as e WHERE e.score >= 90
) AND 
s.student_id IN (
    SELECT student_id from projects as p WHERE p.marks >= 85
)
-- ! We need to have total score student has earned and numbers of exams students has attempted
-- ! We also need to have students's name and branch in the result

SELECT student_id,
    SUM(score) as total_score,
    COUNT(*) as number_of_attempts
FROM exam_scores
GROUP BY student_id;
SELECT 
s.name,
s.branch,
total_stats.total_score,
total_stats.number_of_attempts FROM (
    SELECT student_id,
    SUM(score) as total_score,
    COUNT(*) as number_of_attempts
FROM exam_scores
GROUP BY student_id
) as total_stats
INNER JOIN students as s ON s.student_id = total_stats.student_id
ORDER BY total_stats.total_score DESC;

-- ! For each project get student's name, branch, project marks,
-- ! and their average score on the same row

SELECT student_id,
    AVG(score) as avg_score
from exam_scores
GROUP BY student_id;
SELECT 
s.name,
s.branch,
p.title,
p.marks,
exam_avg.avg_score
FROM
projects as p
INNER JOIN students as s ON s.student_id = p.student_id
INNER JOIN (
    SELECT 
student_id, 
AVG(score) as avg_score 
from exam_scores 
GROUP BY student_id
) as exam_avg ON exam_avg.student_id = p.student_id;


-- ! there is a need of a report where we have list of exam attempts
-- ! which are above average (score > average class score)
-- ! Also include name of the student in the report


CREATE TABLE high_scorers_report (
    id SERIAL PRIMARY KEY,
    student_id INT NOT NULL,
    student_name VARCHAR(50) NOT NULL,
    subject VARCHAR(30) NOT NULL,
    score INT NOT NULL,
    archived_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO high_scorers_report (student_id,
student_name,
subject,
score
)
SELECT 
s.student_id,
s.name,
e.subject,
e.score
FROM exam_scores as e
INNER JOIN students as s ON s.student_id = e.student_id
WHERE e.score > (
    SELECT AVG(score) FROM exam_scores
);

SELECT * from high_scorers_report;