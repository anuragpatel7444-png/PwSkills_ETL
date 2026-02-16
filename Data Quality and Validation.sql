/* ================================================================
   DATA QUALITY AND VALIDATION ASSIGNMENT
   ================================================================ */

/* Q1: Data Quality sirf cleaning nahi hai kyunki isme validation aur monitoring shamil hai[cite: 9].
Q2: Poor data quality se dashboards misleading ho jate hain[cite: 10].
Q3: Duplicate data ke karan: Multiple sources, System failure, aur Human error hain[cite: 11].
Q4: Types: Exact (100% match), Partial (key match), Fuzzy (similar match)[cite: 12].
Q5: Validation transformation ke waqt hona chahiye taaki warehouse clean rahe[cite: 13].
Q6: Business rules accuracy check karte hain, jaise Quantity cannot be Null[cite: 14].
*/

-- Sabse pehle ye tables create karein taaki queries run ho sakein
CREATE TABLE IF NOT EXISTS Customers_Master (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(50),
    City VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Sales_Transactions (
    Txn_ID INT PRIMARY KEY,
    Customer_ID VARCHAR(10),
    Customer_Name VARCHAR(50),
    Product_ID VARCHAR(10),
    Quantity INT,
    Txn_Amount INT,
    Txn_Date DATE,
    City VARCHAR(50)
);

-- Data Insert karein [cite: 16, 21]
INSERT IGNORE INTO Customers_Master VALUES ('C101','Rahul Mehta','Mumbai'), ('C102','Anjali Rao','Bengaluru'), ('C103','Suresh lyer','Chennai'), ('C104','Neha Singh','Delhi');

INSERT IGNORE INTO Sales_Transactions VALUES 
(201,'C101','Rahul Mehta','P11',2,4000,'2025-12-01','Mumbai'),
(202,'C102','Anjali Rao','P12',1,1500,'2025-12-01','Bengaluru'),
(203,'C101','Rahul Mehta','P11',2,4000,'2025-12-01','Mumbai'),
(204,'C103','Suresh lyer','P13',3,6000,'2025-12-02','Chennai'),
(205,'C104','Neha Singh','P14',NULL,2500,'2025-12-02','Delhi'),
(206,'C105','N/A','P15',1,NULL,'2025-12-03','Pune'),
(207,'C106','Amit Verma','P16',1,1800,NULL,'Pune'),
(208,'C101','Rahul Mehta','P11',2,4000,'2025-12-01','Mumbai');

-- ================================================================
-- ANSWER 7: Duplicate detection query [cite: 17, 18]
-- ================================================================

SELECT 
    Customer_ID, 
    Product_ID, 
    Txn_Date, 
    Txn_Amount, 
    COUNT(*) as Duplicate_Count
FROM Sales_Transactions
GROUP BY Customer_ID, Product_ID, Txn_Date, Txn_Amount
HAVING COUNT(*) > 1;

-- ================================================================
-- ANSWER 8: Referential Integrity violation query [cite: 22]
-- ================================================================

SELECT DISTINCT st.Customer_ID
FROM Sales_Transactions st
LEFT JOIN Customers_Master cm ON st.Customer_ID = cm.CustomerID
WHERE cm.CustomerID IS NULL;