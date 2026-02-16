-- Step 0: Safe Update Mode ko disable karein
SET SQL_SAFE_UPDATES = 0;

/* ================================================================================
PART 1: THEORY SECTION (Answers inside comments)
================================================================================
[Q1 to Q7 Answers are covered in comments]
...
[Q9 Extra Note] Why Forward Fill is suitable here?
Answer: Monthly sales data usually follows a trend. Forward fill assumes the 
value hasn't changed, which is safer than averaging in time-series data.
*/

-- ================================================================================
-- PART 2: PRACTICAL SECTION (Runnable Code)
-- ================================================================================

-- --------------------------------------------------------------------------------
-- SETUP: Reset Data
-- --------------------------------------------------------------------------------
DROP TEMPORARY TABLE IF EXISTS temp_customers;
CREATE TEMPORARY TABLE temp_customers (
    Customer_ID INT, Name VARCHAR(50), City VARCHAR(50), 
    Monthly_Sales INT, Income INT, Region VARCHAR(50)
);

INSERT INTO temp_customers VALUES 
(101, 'Rahul', 'Mumbai', 12000, 65000, 'West'),
(102, 'Anjali', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh', 'Chennai', 15000, 72000, 'South'),
(104, 'Neha', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit', 'Pune', 18000, 58000, NULL),
(106, 'Karan', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja', 'Kolkata', 14000, NULL, 'East'),
(108, 'Riya', 'Jaipur', 16000, 69000, 'North');


-- --------------------------------------------------------------------------------
-- [Q8. Listwise Deletion]
-- Task: Remove all rows where Region is missing.
-- --------------------------------------------------------------------------------

-- Task 1: Identify affected rows (Corrected Line)
SELECT * FROM temp_customers WHERE Region IS NULL;

-- Task 3: Count records to be lost
SELECT COUNT(*) AS Total_Records_Lost FROM temp_customers WHERE Region IS NULL;

-- Task 2: Perform Deletion
DELETE FROM temp_customers WHERE Region IS NULL;

-- Show Dataset after deletion
SELECT * FROM temp_customers AS Q8_Final_Dataset;


-- --------------------------------------------------------------------------------
-- [Q9. Imputation - Forward Fill]
-- Task: Handle missing Monthly_Sales using Forward Fill.
-- --------------------------------------------------------------------------------

-- Reset Data for Q9
TRUNCATE TABLE temp_customers;
INSERT INTO temp_customers VALUES 
(101, 'Rahul', 'Mumbai', 12000, 65000, 'West'), (102, 'Anjali', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh', 'Chennai', 15000, 72000, 'South'), (104, 'Neha', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit', 'Pune', 18000, 58000, NULL), (106, 'Karan', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja', 'Kolkata', 14000, NULL, 'East'), (108, 'Riya', 'Jaipur', 16000, 69000, 'North');

-- Logic: Forward Fill using Variables
SET @last_sales = 0;

UPDATE temp_customers 
SET Monthly_Sales = (
    CASE 
        WHEN Monthly_Sales IS NOT NULL THEN @last_sales := Monthly_Sales 
        ELSE @last_sales 
    END
)
ORDER BY Customer_ID;

SELECT * FROM temp_customers AS Q9_Final_Dataset;


-- --------------------------------------------------------------------------------
-- [Q10. Flagging Missing Data]
-- Task: Create a flag column for missing Income.
-- --------------------------------------------------------------------------------

-- Reset Data for Q10
TRUNCATE TABLE temp_customers;
INSERT INTO temp_customers VALUES 
(101, 'Rahul', 'Mumbai', 12000, 65000, 'West'), (102, 'Anjali', 'Bengaluru', NULL, NULL, 'South'),
(103, 'Suresh', 'Chennai', 15000, 72000, 'South'), (104, 'Neha', 'Delhi', NULL, NULL, 'North'),
(105, 'Amit', 'Pune', 18000, 58000, NULL), (106, 'Karan', 'Ahmedabad', NULL, 61000, 'West'),
(107, 'Pooja', 'Kolkata', 14000, NULL, 'East'), (108, 'Riya', 'Jaipur', 16000, 69000, 'North');

-- Task 1: Add Flag Column
ALTER TABLE temp_customers ADD COLUMN Income_Missing_Flag INT;

-- Task 2: Set Flag (1 if missing, 0 if present)
UPDATE temp_customers 
SET Income_Missing_Flag = CASE WHEN Income IS NULL THEN 1 ELSE 0 END;

-- Task 3 & 4: Show updated dataset and Count
SELECT * FROM temp_customers AS Q10_Final_Dataset;

SELECT COUNT(*) as Total_Missing_Incomes 
FROM temp_customers 
WHERE Income_Missing_Flag = 1;

-- Final Step: Enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;