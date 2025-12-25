-- 1. Create database
CREATE DATABASE capstone_project;

-- 2. Select database
USE capstone_project;

-- 3. Rename table
RENAME TABLE `customer-churn-records` TO customer_churn_records;

-- 4. View dataset
SELECT * FROM customer_churn_records;

-- 5. Total customers
SELECT COUNT(CustomerId) AS total_customers
FROM customer_churn_records;

-- 6. Churn vs retained customers
SELECT Exited, COUNT(*) AS total_customers
FROM customer_churn_records
GROUP BY Exited;

-- 7. Average credit score
SELECT AVG(CreditScore) AS average_credit_score
FROM customer_churn_records;

-- 8. Customers by geography
SELECT Geography, COUNT(CustomerId) AS total_customers
FROM customer_churn_records
GROUP BY Geography;

-- 9. Customers by gender
SELECT Gender, COUNT(CustomerId) AS total_customers
FROM customer_churn_records
GROUP BY Gender;

-- 10. Zero balance customers
SELECT COUNT(CustomerId) AS zero_balance_customers
FROM customer_churn_records
WHERE Balance = 0;

-- 11. Avg balance of churned customers
SELECT AVG(Balance) AS average_balance_churned
FROM customer_churn_records
WHERE Exited = 1;

-- 12. Churn rate by geography
SELECT Geography,
       ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn_records
GROUP BY Geography
ORDER BY churn_rate DESC;

-- 13. Avg tenure of retained customers
SELECT AVG(Tenure) AS average_tenure_non_churned
FROM customer_churn_records
WHERE Exited = 0;

-- 14. Top 5 high-salary churned customers
SELECT Surname, CustomerId, EstimatedSalary
FROM customer_churn_records
WHERE Exited = 1
ORDER BY EstimatedSalary DESC
LIMIT 5;

-- 15. Active users with more than 2 products
SELECT COUNT(*) AS active_members_more_than_2_products
FROM customer_churn_records
WHERE IsActiveMember = 1 AND NumOfProducts > 2;

-- 16. Avg balance by activity status
SELECT IsActiveMember, AVG(Balance) AS average_balance
FROM customer_churn_records
GROUP BY IsActiveMember;

-- 17. Avg salary by gender
SELECT Gender, AVG(EstimatedSalary) AS average_estimated_salary
FROM customer_churn_records
GROUP BY Gender;

-- 18. Churn count by tenure
SELECT Tenure, COUNT(*) AS total_churned_customers
FROM customer_churn_records
WHERE Exited = 1
GROUP BY Tenure
ORDER BY Tenure;

-- 19. Churn rate by number of products
SELECT NumOfProducts,
       ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn_records
GROUP BY NumOfProducts
ORDER BY NumOfProducts;

-- 20. Churn rate by age group
SELECT CASE 
        WHEN Age BETWEEN 18 AND 30 THEN '18–30'
        WHEN Age BETWEEN 31 AND 45 THEN '31–45'
        WHEN Age BETWEEN 46 AND 60 THEN '46–60'
        WHEN Age > 60 THEN '60+'
        ELSE 'Below 18'
    END AS age_group,
    ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn_records
GROUP BY age_group
ORDER BY age_group;

-- 21. Churn rate by geography and gender
SELECT Geography, Gender,
       ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate
FROM customer_churn_records
GROUP BY Geography, Gender
ORDER BY churn_rate DESC;

-- 22. Profile of churned users by geography
SELECT Geography,
       AVG(CreditScore) AS average_credit_score,
       AVG(Balance) AS average_balance
FROM customer_churn_records
WHERE Exited = 1
GROUP BY Geography;

-- 23. Churn rate without credit card
SELECT ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS churn_rate_no_credit_card
FROM customer_churn_records
WHERE HasCrCard = 0;

-- 24. High balance above churned average
SELECT CustomerID, SurName, Balance
FROM customer_churn_records
WHERE Balance > (
        SELECT AVG(Balance)
        FROM customer_churn_records
        WHERE Exited = 1
    )
ORDER BY Balance DESC;

-- 25. Countries above overall churn rate
SELECT Geography AS country,
       ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS country_churn_rate
FROM customer_churn_records
GROUP BY Geography
HAVING country_churn_rate >
(
    SELECT ROUND(100.0 * SUM(CASE WHEN Exited = 1 THEN 1 ELSE 0 END) / COUNT(*), 2)
    FROM customer_churn_records
)
ORDER BY country_churn_rate DESC;
