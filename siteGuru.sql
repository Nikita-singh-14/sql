Write a query to return User Name and Total Number of Orders for every user.

Tables:
 users ( id, name )
 orders ( id, user_id, amount )
•	Write the query.
•	Explain the JOIN used.
•	Explain the GROUP BY clause.

CREATE TABLE users(
    user_id INT PRIMARY KEY,
    user_name VARCHAR(20),
    user_age INT
);

INSERT INTO users(
    user_id,
    user_name,
    user_age
)VALUES
(1, 'anu', 22),
(2, 'aditya', 23),
(3, 'ashu', 20);

SELECT * FROM users;

1) return all users whose age is greater than 18
SELECT * FROM users WHERE user_age > 18;

2) return all users sorted by name in ascending order.
SELECT * FROM users ORDER BY user_name ASC;

3) return User Name and Total Number of Orders for every user.
CREATE TABLE orders(
    order_id INT PRIMARY KEY,
    userO_id INT,
    amount INT
);

INSERT INTO orders(
    order_id,
    userO_id,
    amount
)VALUES
(1, 1, 100),
(2, 1, 230),
(3, 2, 200),
(4, 1, 570),
(5, 2, 220),
(6, 3, 260);

SELECT u.user_name, 
COUNT(o.userO_id) AS total_orders
FROM users AS u
JOIN orders AS o ON u.user_id = o.usero_id
GROUP BY u.user_id;

4) return User Name, Total Number of Orders, and Total Order Amount, sorted by Total Order Amount in descending order.
SELECT u.user_name, 
COUNT(o.userO_id) AS no_of_orders,
SUM(o.amount) AS total_amount
FROM users AS u
JOIN orders AS o ON u.user_id = o.usero_id
GROUP BY u.user_id ORDER BY total_amount DESC;

5) Explain the difference between INNER JOIN and LEFT JOIN in MySQL.
•	What does INNER JOIN return?
•	What does LEFT JOIN return?
•	Provide one example where their results would differ.

6)Write a MySQL query to find the employee with the highest salary in each department.

Table: employees ( id, name, department, salary )
•	Write the query.
•	Explain your approach step by step.
•	If you use a subquery or GROUP BY, explain why.
