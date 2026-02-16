/* ================================================================
FINAL ASSIGNMENT: DATA QUALITY & ETL LOADING (PART 1 & 2)
================================================================
NAME: Anurag
TOPICS: Data Validation, Quality Checks, and ETL Strategies
================================================================
*/

/* PART 1: DATA QUALITY & VALIDATION (ETL33.PDF)
----------------------------------------------------------------
[cite_start]Q1: Data Quality sirf cleaning nahi hai kyunki isme validation aur continuous monitoring shamil hai. [cite: 8, 9]
[cite_start]Q2: Poor data quality se dashboards misleading ho jate hain aur galat business decisions liye jate hain. [cite: 10]
[cite_start]Q3: Duplicates ke karan: Multiple data sources, system/network failure, aur manual errors. [cite: 11]
[cite_start]Q4: Types: Exact (100% match), Partial (sirf key match), aur Fuzzy (similar spelling). [cite: 12]
[cite_start]Q5: Validation transformation ke waqt hona chahiye taaki warehouse mein galat data load na ho. [cite: 13]
[cite_start]Q6: Business rules accuracy check karte hain, jaise "Quantity cannot be Null". [cite: 14, 16]

PART 2: DATA LOADING ISSUES (ETL44.PDF)
----------------------------------------------------------------
[cite_start]Q1: Dataset Issues: Duplicates, Missing values, Wrong data types, aur mixed date formats. [cite: 35]
[cite_start]Q2: Primary Key Violation: Order_ID '0101' repeat ho raha hai. [cite: 30, 38, 39]
[cite_start]Q3: Missing Values: Order_ID '0102' mein Sales_Amount Null hai. [cite: 30, 41]
[cite_start]Q4: Data Type Error: Order_ID '0104' mein 'Three Thousand' text hai, jo numeric fail hoga. [cite: 30, 46]
[cite_start]Q5: Date Format: DD-MM-YYYY aur YYYY/MM/DD mixed hain, jo sorting mein problem karenge. [cite: 49, 51]
Q6: Decision: No, directly load nahi karna chahiye. [cite_start]Reasons: PK violation, Nulls, aur Data Type issues. [cite: 54, 55]
[cite_start]Q9: Strategy: Incremental Load use karna chahiye kyunki ye daily sales data hai. [cite: 63, 64]
*/

-- ================================================================
-- PRACTICAL QUERIES FOR SUBMISSION
-- ================================================================

-- 1. DETECTING DUPLICATES (Business Key: Customer_ID + Product_ID + Date + Amount)
SELECT Customer_ID, Product_ID, Txn_Date, Txn_Amount, COUNT(*) 
FROM Sales_Transactions 
GROUP BY Customer_ID, Product_ID, Txn_Date, Txn_Amount 
HAVING COUNT(*) > 1;

-- 2. DETECTING REFERENTIAL INTEGRITY VIOLATIONS
SELECT DISTINCT st.Customer_ID 
FROM Sales_Transactions st 
LEFT JOIN Customers_Master cm ON st.Customer_ID = cm.CustomerID 
WHERE cm.CustomerID IS NULL;

-- 3. DETECTING DATA TYPE ERRORS (Text in Numeric field)
SELECT * FROM Sales_Data 
WHERE Sales_Amount REGEXP '[^0-9]';

-- 4. DETECTING NULL VALUES IN CRITICAL COLUMNS
SELECT * FROM Sales_Data 
WHERE Sales_Amount IS NULL;