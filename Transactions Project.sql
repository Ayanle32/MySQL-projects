CREATE TABLE transactions (
	ID INT PRIMARY KEY AUTO_INCREMENT,
    amount DECIMAL(5,2),
    category VARCHAR(50),
    transaction_date DATE
);

INSERT INTO transactions (amount, category, transaction_date)
VALUES  (2.90, "Groceries", "2023-12-12"),
        (0.80, "Takeaway", "2023-12-12"),
        (0.80, "Takeaway", "2023-12-12"),
        (1.60, "Takeaway", "2023-12-12"),
        (3.74, "Takeaway", "2023-12-12");
        
SELECT DISTINCT category FROM transactions;

-- So we have 7 transaction categories in our table
-- We do this to ensure we do not have typos.


SELECT SUM(amount), category 
FROM transactions
GROUP BY category
ORDER BY SUM(amount) DESC;

-- 	We spent the most on bills (£824.52) and the least on clothing (£122.49).

SELECT amount, category, transaction_date FROM transactions
WHERE amount = (SELECT MAX(amount)
FROM transactions);

-- The largest transaction was £166.98 on an household item and it happened 4th September 2023.

SELECT SUM(amount) AS "Total Spending", MONTH(transaction_date) AS "Month Number"
FROM transactions
GROUP BY MONTH(transaction_date)
ORDER BY SUM(amount) DESC;

-- We Spent the most in the month of October (£801.34) and the least in the month of June (£244.31)

SELECT COUNT(amount) AS "Number of transactions", category 
FROM transactions
GROUP BY category
ORDER BY COUNT(amount) DESC;

-- The eating out category has the most transactions at 138 and clothing has the least at 3 transactions.

SELECT AVG(amount) AS "Average transaction amount", category 
FROM transactions
GROUP BY category
ORDER BY AVG(amount) DESC;

-- Household Items have the highest average transaction amount and eating out has the least average transactions amount

CREATE VIEW total_spends AS
SELECT SUM(amount) AS "Total Spending", category 
FROM transactions
GROUP BY category
ORDER BY SUM(amount) DESC;

SELECT * FROM total_spends;

-- So here we created a view for the total transactions for each category.
-- This will be particularly useful for creating visualisations in some BI tool.

CREATE VIEW monthly_spending AS
SELECT SUM(amount) AS "Total Spending by Month", MONTH(transaction_date) AS "Month Number"
FROM transactions
GROUP BY MONTH(transaction_date)
ORDER BY SUM(amount) DESC;

SELECT * FROM monthly_spending;

SELECT * FROM transactions;
