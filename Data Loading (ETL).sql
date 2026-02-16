/* ================================================================
   ASSIGNMENT: DATA LOADING (ETL) - COMPLETE SOLUTIONS (Q1-Q10) 
   ================================================================

Q1. DATA UNDERSTANDING: Identify all data quality issues. [cite: 34]
ANSWER: The following data quality issues are present in the dataset[cite: 30, 35]:
- Duplicate Records: Order_ID '0101' appears twice[cite: 30].
- Missing Values: Order_ID '0102' has a 'Null' Sales_Amount[cite: 30].
- Data Type Mismatch: Order_ID '0104' contains text ('Three Thousand') instead of numbers[cite: 30].
- Inconsistent Date Formats: Mixed formats like DD-MM-YYYY ('12-01-2024') and YYYY/MM/DD ('2024/01/18') are used[cite: 30].

Q2. PRIMARY KEY VALIDATION [cite: 36]
a) Is the dataset violating the Primary Key rule? YES[cite: 30, 38].
b) Which record(s) cause this violation? Order_ID '0101' because it is a duplicate[cite: 30, 39].

Q3. MISSING VALUE ANALYSIS [cite: 40]
- Column(s) with missing values: Sales_Amount[cite: 30, 41].
a) Affected records: Order_ID '0102'[cite: 30, 42].
b) Risk: Loading nulls can lead to incorrect financial totals and may cause system crashes if the column has a 'NOT NULL' constraint[cite: 43].

Q4. DATA TYPE VALIDATION [cite: 44]
a) Failed records: Order_ID '0104' ('Three Thousand')[cite: 30, 46].
b) SQL Impact: Loading this into a DECIMAL column will cause an "Invalid numeric value" error and the load will fail[cite: 47].

Q5. DATE FORMAT CONSISTENCY [cite: 48]
a) Date formats: DD-MM-YYYY (e.g., 12-01-2024) and YYYY/MM/DD (e.g., 2024/01/18)[cite: 30, 50].
b) Problem: Inconsistent formats prevent correct sorting and cause errors in reporting tools during filtering[cite: 51].

Q6. LOAD READINESS DECISION [cite: 52]
a) Load directly? NO[cite: 54].
b) Justification: 1. Duplicate Primary Keys [cite: 30, 55], 2. Null values in critical fields [cite: 30, 55], 3. Data type mismatch[cite: 30, 55].

Q7. PRE-LOAD VALIDATION CHECKLIST [cite: 57]
- Uniqueness Check: Ensure Order_ID is unique[cite: 58].
- Null Value Check: Identify mandatory fields with missing values[cite: 58].
- Data Type Check: Ensure Sales_Amount is numeric[cite: 58].
- Date Format Validation: Verify consistent date structures[cite: 58].

Q8. CLEANING STRATEGY [cite: 59]
- Step 1: Remove or merge duplicate records for Order_ID '0101'[cite: 60].
- Step 2: Handle the Null value for Order_ID '0102'[cite: 60].
- Step 3: Convert the string 'Three Thousand' to the numeric value 3000[cite: 60].
- Step 4: Transform all dates into a standardized format (YYYY-MM-DD)[cite: 60].

Q9. LOADING STRATEGY SELECTION [cite: 61]
a) Choice: Incremental Load[cite: 63].
b) Justification: It is more efficient for daily sales data as it only loads new or changed records[cite: 62, 64].

Q10. BI IMPACT SCENARIO [cite: 65]
a) Incorrect Result: Total Sales KPI will be higher than actual due to duplicate counting[cite: 67].
b) Misleading records: '0101' (duplicates) and '0104' (incorrect type)[cite: 30, 68].
c) BI Limit: BI tools simply display data; they do not automatically detect logic or entry errors without pre-defined rules[cite: 69].

================================================================
SQL PRACTICAL QUERIES
================================================================
*/

-- Query to find duplicate Order_IDs
SELECT Order_ID, COUNT(*) 
FROM Sales_Data 
GROUP BY Order_ID 
HAVING COUNT(*) > 1;

-- Query to detect non-numeric Sales_Amount
SELECT * FROM Sales_Data 
WHERE Sales_Amount REGEXP '[^0-9]';

-- Query to detect NULL values
SELECT * FROM Sales_Data 
WHERE Sales_Amount IS NULL;
