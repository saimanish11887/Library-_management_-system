-- =====================================================
-- Library Management System
-- File    : 04_dql.sql
-- Purpose : Data Query Language (SELECT queries)
-- NOTE    : Run after 03_dml.sql, connected to "library_management".
-- =====================================================


-- -----------------------------------------------------
-- 1. Display Available Books
-- -----------------------------------------------------
SELECT b.title,
       bc.accession_no
FROM books b
JOIN book_copies bc USING (book_id)
WHERE bc.status = 'Available';


-- -----------------------------------------------------
-- 2. Display Currently Issued Books
-- -----------------------------------------------------
SELECT m.name,
       b.title,
       l.issue_date,
       l.due_date
FROM loans l
JOIN members m      USING (member_id)
JOIN book_copies bc USING (copy_id)
JOIN books b        USING (book_id)
WHERE l.return_date IS NULL;


-- -----------------------------------------------------
-- 3. Display Overdue Books
-- -----------------------------------------------------
SELECT *
FROM loans
WHERE return_date IS NULL
  AND due_date < CURRENT_DATE;


-- -----------------------------------------------------
-- 4. Display Book Count by Category
-- -----------------------------------------------------
SELECT c.category_name,
       COUNT(b.book_id) AS book_count
FROM categories c
LEFT JOIN books b USING (category_id)
GROUP BY c.category_name;


-- -----------------------------------------------------
-- 5. Fine Calculation for Overdue Loans (Rs. 5.00 per day)
-- -----------------------------------------------------
SELECT l.loan_id,
       m.name AS member_name,
       b.title,
       CURRENT_DATE - l.due_date          AS overdue_days,
       (CURRENT_DATE - l.due_date) * 5.00 AS calculated_fine
FROM loans l
JOIN members m      ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id   = bc.copy_id
JOIN books b        ON bc.book_id  = b.book_id
WHERE l.return_date IS NULL
  AND l.due_date < CURRENT_DATE;