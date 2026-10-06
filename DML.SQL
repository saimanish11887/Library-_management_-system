-- =====================================================
-- Library Management System
-- File    : 03_dml.sql
-- Purpose : Data Manipulation Language (sample data + updates)
-- NOTE    : Run after 02_ddl.sql, connected to "library_management".
-- =====================================================


-- =====================================================
-- SECTION A: INSERT STATEMENTS
-- =====================================================

-- A1. Publishers
INSERT INTO publishers (publisher_name)
VALUES
    ('Pearson'),
    ('OReilly Media');

-- A2. Categories
INSERT INTO categories (category_name)
VALUES
    ('Computer Science'),
    ('Fiction'),
    ('Artificial Intelligence');

-- A3. Authors
INSERT INTO authors (author_name)
VALUES
    ('Ramez Elmasri'),
    ('Robert C. Martin'),
    ('Stuart Russell');

-- A4. Books
INSERT INTO books (isbn, title, publisher_id, category_id, publication_year)
VALUES
    ('9780133970777', 'Database Systems', 1, 1, 2016),
    ('9780132350884', 'Clean Code', 1, 1, 2008),
    ('9780134610993', 'Artificial Intelligence: A Modern Approach', 2, 3, 2021);

-- A5. Book Authors (links books to authors)
INSERT INTO book_authors
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

-- A6. Book Copies
INSERT INTO book_copies (book_id, accession_no)
VALUES
    (1, 'ACC-001'),
    (1, 'ACC-002'),
    (2, 'ACC-003'),
    (3, 'ACC-004');

-- A7. Members
INSERT INTO members (name, email, phone)
VALUES
    ('Anil Kumar',  'anil@example.com',  '9876543210'),
    ('Priya Reddy', 'priya@example.com', '9876501234');

-- A8. Staff
INSERT INTO staff (name, email, role)
VALUES
    ('Library Admin', 'admin@library.edu',   'Admin'),
    ('S. Lakshmi',    'lakshmi@library.edu', 'Librarian');

-- A9. Loans (issue copy 1 to member 1, handled by staff 2, due in 14 days)
INSERT INTO loans (copy_id, member_id, staff_id, due_date)
VALUES
    (1, 1, 2, CURRENT_DATE + 14);

-- A10. Reservations (member 2 reserves book 3)
INSERT INTO reservations (book_id, member_id)
VALUES
    (3, 2);


-- =====================================================
-- SECTION B: UPDATE STATEMENTS
-- =====================================================

-- B1. Mark the issued copy as 'Issued'
UPDATE book_copies
SET status = 'Issued'
WHERE copy_id = 1;

-- B2. Return a book: record the return date on the loan
UPDATE loans
SET return_date = CURRENT_DATE
WHERE loan_id = 1;

-- B3. Return a book: make the returned copy 'Available' again
UPDATE book_copies
SET status = 'Available'
WHERE copy_id = (
    SELECT copy_id
    FROM loans
    WHERE loan_id = 1
);