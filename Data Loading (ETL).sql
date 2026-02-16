/* ================================================================
   ASSIGNMENT: DATA LOADING (ETL) - COMPLETE SOLUTIONS (Q1-Q10)
   ================================================================

Q1. DATA UNDERSTANDING: Identify all data quality issues.
[cite_start]ANSWER: Dataset mein niche diye gaye data quality issues hain[cite: 35]:
- [cite_start]Duplicate Records: Order_ID '0101' do baar repeat ho raha hai[cite: 30].
- [cite_start]Missing Values: Order_ID '0102' mein Sales_Amount 'Null' hai[cite: 30].
- [cite_start]Data Type Mismatch: Order_ID '0104' mein number ki jagah 'Three Thousand' text likha hai[cite: 30].
- [cite_start]Date Inconsistency: Dates alag formats mein hain (DD-MM-YYYY aur YYYY/MM/DD)[cite: 30, 49].

Q2. PRIMARY KEY VALIDATION
a) Is the dataset violating the Primary Key rule? [cite_start]YES[cite: 38].
b) Which record(s) cause this violation? [cite_start]Order_ID '0101' kyunki ye duplicate hai[cite: 30, 39].

Q3. MISSING VALUE ANALYSIS
- [cite_start]Column: Sales_Amount[cite: 30, 41].
[cite_start]a) Affected records: Order_ID '0102'[cite: 30, 42].
[cite_start]b) Risk: Handling ke bina load karne se reporting mein galat Total Sales dikhegi aur aggregate functions (SUM, AVG) fail ho sakte hain[cite: 43].

Q4. DATA TYPE VALIDATION
[cite_start]a) Failed records: Order_ID '0104' ('Three Thousand') numeric validation fail karega[cite: 30, 46].
[cite_start]b) SQL Impact: Agar column DECIMAL hai, toh SQL "Invalid numeric value" error dega aur data load fail ho jayega[cite: 47].

Q5. DATE FORMAT CONSISTENCY
[cite_start]a) Date formats: DD-MM-YYYY (12-01-2024) aur YYYY/MM/DD (2024/01/18)[cite: 30, 50].
[cite_start]b) Problem: Database dates ko sahi se sort nahi kar payega aur reporting tools ise recognize nahi karenge[cite: 51].

Q6. LOAD READINESS DECISION
a) Load directly? [cite_start]NO[cite: 54].
[cite_start]b) Justification: 1. Primary Key violation, 2. Data type mismatch, 3. Missing critical values (Nulls)[cite: 30, 55].

Q7. PRE-LOAD VALIDATION CHECKLIST
- [cite_start]Uniqueness Check (Order_ID duplicate check)[cite: 58].
- [cite_start]Null Value Check (Mandatory columns check)[cite: 58].
- [cite_start]Data Type Validation (Numeric check for Sales_Amount)[cite: 58].
- [cite_start]Format Standardization Check (Date format check)[cite: 58].

Q8. CLEANING STRATEGY
- [cite_start]Step 1: Duplicate Order_IDs ko remove ya merge karein[cite: 60].
- [cite_start]Step 2: 'Null' Sales_Amount ko 0 ya logic ke hisab se fill karein[cite: 60].
- [cite_start]Step 3: Text 'Three Thousand' ko numeric 3000 mein convert karein[cite: 60].
- [cite_start]Step 4: Saari dates ko ek standard SQL format (YYYY-MM-DD) mein badlein[cite: 60].

Q9. LOADING STRATEGY SELECTION
[cite_start]a) Choice: Incremental Load[cite: 63].
[cite_start]b) Justification: Daily sales data ke liye sirf naya data load karna fast aur resources ke liye behtar hota hai[cite: 62, 64].

Q10. BI IMPACT SCENARIO
[cite_start]a) Incorrect Result: Total Sales KPI double counting ki wajah se galat (zyada) dikhegi[cite: 67].
[cite_start]b) Misleading records: '0101' (Duplicate) aur '0104' (Data type issue)[cite: 30, 68].
[cite_start]c) Why BI won't detect: BI tools data logic nahi samajhte, wo sirf database se mila raw data display karte hain[cite: 69].

================================================================
SQL PRACTICAL QUERIES
================================================================
*/

-- 1. Query to find duplicate Order_IDs
SELECT Order_ID, COUNT(*) 
FROM Sales_Data 
GROUP BY Order_ID 
HAVING COUNT(*) > 1;

-- 2. Query to detect records with non-numeric Sales_Amount
SELECT * FROM Sales_Data 
WHERE Sales_Amount REGEXP '[^0-9]';

-- 3. Query to detect NULL values
SELECT * FROM Sales_Data 
WHERE Sales_Amount IS NULL;
