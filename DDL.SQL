-- =====================================================
-- Library Management System
-- File    : 01_create_database.sql
-- Purpose : Creates the project database
-- NOTE    : Execute this file while connected to the
--           default "postgres" database. A database
--           cannot be created from inside itself.
-- =====================================================

CREATE DATABASE library_management;
-- =====================================================
-- Library Management System
-- File    : 02_ddl.sql
-- Purpose : Data Definition Language (tables, index, view)
-- NOTE    : Connect to the "library_management" database
--           before running this file.
-- =====================================================


-- -----------------------------------------------------
-- 1. Publishers
-- -----------------------------------------------------
CREATE TABLE publishers (
    publisher_id    SERIAL PRIMARY KEY,
    publisher_name  VARCHAR(120) NOT NULL UNIQUE
);


-- -----------------------------------------------------
-- 2. Categories
-- -----------------------------------------------------
CREATE TABLE categories (
    category_id    SERIAL PRIMARY KEY,
    category_name  VARCHAR(80) NOT NULL UNIQUE
);


-- -----------------------------------------------------
-- 3. Authors
-- -----------------------------------------------------
CREATE TABLE authors (
    author_id    SERIAL PRIMARY KEY,
    author_name  VARCHAR(120) NOT NULL
);


-- -----------------------------------------------------
-- 4. Books
-- -----------------------------------------------------
CREATE TABLE books (
    book_id           SERIAL PRIMARY KEY,
    isbn              VARCHAR(20) UNIQUE NOT NULL,
    title             VARCHAR(200) NOT NULL,
    publisher_id      INT NOT NULL REFERENCES publishers(publisher_id),
    category_id       INT NOT NULL REFERENCES categories(category_id),
    publication_year  INT CHECK (publication_year BETWEEN 1000 AND 2100)
);


-- -----------------------------------------------------
-- 5. Book Authors (Many-to-Many: books <-> authors)
-- -----------------------------------------------------
CREATE TABLE book_authors (
    book_id    INT NOT NULL REFERENCES books(book_id)     ON DELETE CASCADE,
    author_id  INT NOT NULL REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (book_id, author_id)
);


-- -----------------------------------------------------
-- 6. Book Copies (physical copies of each book)
-- -----------------------------------------------------
CREATE TABLE book_copies (
    copy_id       SERIAL PRIMARY KEY,
    book_id       INT NOT NULL REFERENCES books(book_id),
    accession_no  VARCHAR(30) UNIQUE NOT NULL,
    status        VARCHAR(20) DEFAULT 'Available'
                  CHECK (status IN ('Available', 'Issued', 'Lost', 'Damaged'))
);


-- -----------------------------------------------------
-- 7. Members
-- -----------------------------------------------------
CREATE TABLE members (
    member_id  SERIAL PRIMARY KEY,
    name       VARCHAR(120) NOT NULL,
    email      VARCHAR(150) UNIQUE NOT NULL,
    phone      VARCHAR(20),
    join_date  DATE DEFAULT CURRENT_DATE,
    status     VARCHAR(15) DEFAULT 'Active'
               CHECK (status IN ('Active', 'Inactive'))
);


-- -----------------------------------------------------
-- 8. Staff
-- -----------------------------------------------------
CREATE TABLE staff (
    staff_id  SERIAL PRIMARY KEY,
    name      VARCHAR(120) NOT NULL,
    email     VARCHAR(150) UNIQUE NOT NULL,
    role      VARCHAR(20) CHECK (role IN ('Librarian', 'Admin'))
);


-- -----------------------------------------------------
-- 9. Loans (book issue / return records)
-- -----------------------------------------------------
CREATE TABLE loans (
    loan_id      SERIAL PRIMARY KEY,
    copy_id      INT NOT NULL REFERENCES book_copies(copy_id),
    member_id    INT NOT NULL REFERENCES members(member_id),
    staff_id     INT NOT NULL REFERENCES staff(staff_id),
    issue_date   DATE DEFAULT CURRENT_DATE,
    due_date     DATE NOT NULL,
    return_date  DATE,
    CHECK (due_date >= issue_date),
    CHECK (return_date IS NULL OR return_date >= issue_date)
);


-- -----------------------------------------------------
-- 10. Reservations
-- -----------------------------------------------------
CREATE TABLE reservations (
    reservation_id    SERIAL PRIMARY KEY,
    book_id           INT NOT NULL REFERENCES books(book_id),
    member_id         INT NOT NULL REFERENCES members(member_id),
    reservation_date  DATE DEFAULT CURRENT_DATE,
    status            VARCHAR(15) DEFAULT 'Pending'
                      CHECK (status IN ('Pending', 'Fulfilled', 'Cancelled'))
);


-- -----------------------------------------------------
-- 11. Fines
-- -----------------------------------------------------
CREATE TABLE fines (
    fine_id      SERIAL PRIMARY KEY,
    loan_id      INT UNIQUE NOT NULL REFERENCES loans(loan_id),
    amount       NUMERIC(8,2) NOT NULL CHECK (amount >= 0),
    paid_status  BOOLEAN DEFAULT FALSE,
    paid_date    DATE,
    CHECK (
        (paid_status = FALSE AND paid_date IS NULL)
        OR
        (paid_status = TRUE  AND paid_date IS NOT NULL)
    )
);


-- -----------------------------------------------------
-- 12. Index: a copy can have only one active (unreturned) loan
-- -----------------------------------------------------
CREATE UNIQUE INDEX one_active_loan_per_copy
    ON loans(copy_id)
    WHERE return_date IS NULL;


-- -----------------------------------------------------
-- 13. View: all loans that have not been returned yet
-- -----------------------------------------------------
CREATE VIEW current_loans AS
SELECT *
FROM loans
WHERE return_date IS NULL;