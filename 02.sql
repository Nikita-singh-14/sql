SELECT *
from exam_scores as e;

SELECT e.subject,
    SUM(e.score) AS subject_total
FROM exam_scores as e
GROUP BY e.subject;
-- windows function
SELECT *,
    SUM(e.score) OVER(PARTITION BY e.subject) as subject_total
FROM exam_scores as e;

-- Bank Passbook
Initial balance - 0

31st Dec 100 rupees 100
1st Jan 500 rupees 600
2nd jan 200 rupees 800
3rs jan 1000 rupees 1800

-- ! Rolling total / comulative sum

CREATE TABLE bank_transactions (
    transaction_id INT PRIMARY KEY,
    account_holder VARCHAR(100),
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount DECIMAL(10,2)
);

INSERT INTO bank_transactions (
    transaction_id,
    account_holder,
    transaction_date,
    transaction_type, 
    amount 
)
VALUES
(1, 'Shubham', '2026-01-01', 'DEPOSIT', 1000),
(2, 'Shubham', '2026-01-03', 'WITHDRAW', -200),
(3, 'Shubham', '2026-01-05', 'DEPOSIT', 500),
(4, 'Shubham', '2026-01-07', 'WITHDRAW', -100),
(5, 'Rahul', '2026-01-01', 'DEPOSIT', 2000),
(6, 'Rahul', '2026-01-04', 'WITHDRAW', -300),
(7, 'Rahul', '2026-01-06', 'DEPOSIT', 400);

SELECT * FROM bank_transactions;

SELECT *,
SUM(amount) OVER(
    PARTITION BY account_holder
    ORDER BY transaction_date
) AS closing_valance FROM bank_transactions;

--! Ranking windows function
-- ? ROW_NUMBER(), RANK(), DENSE_RANK()

INSERT INTO exam_scores (
    student_id,
    subject,
    score,
    exam_month
)
VALUES
(7, 'English', 94, '2026-11'),
(7, 'History', 95, '2026-11'),
(5, 'Math', 50, '2026-03'),
(5, 'SQL', 50, '2026-10');


SELECT * FROM students;
SELECT * FROM exam_scores;

SELECT e.student_id,
s.name,
s.branch,
SUM(score) AS total_score,
ROW_NUMBER() OVER(PARTITION BY s.branch
ORDER BY SUM(e.score) DESC
) AS row_num,
RANK() OVER(PARTITION BY s.branch
ORDER BY SUM(e.score) DESC
) AS rank_num,
DENSE_RANK() OVER(
    PARTITION BY s.branch
ORDER BY SUM(e.score) DESC
) AS dense_rank_num
FROM exam_scores AS e 
INNER JOIN students as s ON s.student_id = e.student_id
GROUP BY e.student_id, s.name, s.branch;