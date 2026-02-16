/* ================================================================
   ASSIGNMENT: ETL DATA QUALITY & LOADING (COMPLETE)
   ================================================================
   PART 1: DATA QUALITY & VALIDATION (ETL33.PDF)
   ----------------------------------------------------------------
   Q1: Data Quality accuracy, completeness aur consistency ensure karta hai[cite: 9].
   Q2: Poor quality se "Garbage In, Garbage Out" hota hai aur dashboards galat metrics dikhate hain[cite: 10].
   Q3: Duplicates ke karan: Multiple sources, System failures, aur Human errors[cite: 11].
   Q4: Types: Exact (100% match), Partial (key match), Fuzzy (similar match)[cite: 12].
   Q5: Transformation ke waqt validation cost bachta hai aur integrity maintain karta hai[cite: 13].
   Q6: Business rules accuracy check karte hain, e.g., "Quantity cannot be Null"[cite: 14].
   Q7 & Q8: SQL Queries niche di gayi hain[cite: 17, 22].

   PART 2: DATA LOADING ISSUES (ETL44.PDF)
   ----------------------------------------------------------------
   Q1: Issues: Duplicates, Nulls, Wrong types, mixed dates.
   Q2: PK Violation: Order_ID '0101' repeat ho raha hai[cite: 38].
   Q3: Missing Values: Order_ID '0102' mein Sales_Amount NULL hai[cite: 42].
   Q4: Type Error: Order_ID '0104' ('Three Thousand') load error dega[cite: 46].
   Q5: Format Issue: Dates DD-MM-YYYY aur YYYY/MM/DD mixed hain[cite: 50].
   Q6: Decision: No direct load. Reasons: PK violation, Nulls, aur Type errors[cite: 54].
   Q7: Checklist: Uniqueness, Null check, Type validation[cite: 58].
   Q8: Strategy: Remove duplicates, handle nulls, fix types/dates[cite: 60].
   Q9: Loading Strategy: Incremental Load (for daily sales)[cite: 63].
   Q10: BI Impact: Double counting aur calculations mein error[cite: 67].
   ================================================================ */

-- SQL QUERIES (RUN THESE IN WORKBENCH)

-- 1. PDF 1: Duplicate Key Detection [cite: 17]
SELECT Customer_ID, Product_ID, Txn_Date, Txn_Amount, COUNT(*) 
FROM Sales_Transactions 
GROUP BY Customer_ID, Product_ID, Txn_Date, Txn_Amount 
HAVING COUNT(*) > 1;

-- 2. PDF 1: Referential Integrity Check [cite: 22]
SELECT DISTINCT st.Customer_ID FROM Sales_Transactions st 
LEFT JOIN Customers_Master cm ON st.Customer_ID = cm.CustomerID 
WHERE cm.CustomerID IS NULL;

-- 3. PDF 2: Data Type Check (Non-numeric values) [cite: 45]
SELECT * FROM Sales_Data WHERE Sales_Amount REGEXP '[^0-9]';

-- 4. PDF 2: Null Check [cite: 41]
SELECT * FROM Sales_Data WHERE Sales_Amount IS NULL;

-- 5. PDF 2: Primary Key Violation Check [cite: 36]
SELECT Order_ID, COUNT(*) FROM Sales_Data GROUP BY Order_ID HAVING COUNT(*) > 1;
