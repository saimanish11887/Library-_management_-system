# Library-_management_-system
DBMS CAPSTONE PROJECT
# 📚 Library Management System

A relational database project for managing a library, built with **PostgreSQL**.

## 📖 Project Description

The Library Management System stores and manages information about books, authors,
publishers, categories, physical book copies, members, staff, book loans,
reservations, and fines. The schema is normalized and enforces data integrity
through keys and constraints.

## 🎯 Objective

- Design a normalized relational schema for a library.
- Enforce data integrity using constraints, an index, and a view.
- Demonstrate DDL, DML, and DQL operations using sample data and queries.

## 🛠 Technologies Used

- PostgreSQL
- SQL (DDL, DML, DQL)
- psql / pgAdmin
- Git & GitHub

## 🗄 Database Used

**PostgreSQL** (database name: `library_management`)

## 🧠 SQL Concepts Used

| Concept | Usage in this project |
|---|---|
| **DDL** | `CREATE TABLE`, `CREATE UNIQUE INDEX`, `CREATE VIEW` |
| **DML** | `INSERT`, `UPDATE` |
| **DQL** | `SELECT` with joins, `WHERE`, `GROUP BY`, `COUNT` |
| **Primary Key** | Every table (composite key in `book_authors`) |
| **Foreign Key** | Links between books, copies, loans, reservations, fines, etc. |
| **Unique** | ISBN, emails, accession numbers, publisher/category names |
| **Not Null** | Required fields such as titles, names, due dates |
| **Check** | Valid statuses, publication year range, date logic, fine amount |
| **Default** | `CURRENT_DATE`, `'Available'`, `'Active'`, `'Pending'`, `FALSE` |
| **Index** | Partial unique index `one_active_loan_per_copy` |
| **View** | `current_loans` (loans not yet returned) |

## 🧩 Main Modules

- **Publishers**: book publishers
- **Categories**: book subjects/genres
- **Authors**: book authors (many-to-many with books via `book_authors`)
- **Books**: book catalog with ISBN, title, publisher, category, year
- **Book Copies**: physical copies with accession number and status
- **Members**: library members
- **Staff**: librarians and admins
- **Loans**: issue and return records with due dates
- **Reservations**: member reservations for books
- **Fines**: fines linked one-to-one with loans

## 📁 Project Folder Structure

```
Library_Management_System/
│
├── 01_create_database.sql
├── 02_ddl.sql
├── 03_dml.sql
├── 04_dql.sql
└── README.md
```

## ⚙️ Installation / Execution Steps

1. Install PostgreSQL and make sure `psql` is available.
2. Clone the repository:
```bash
   git clone <your-repository-url>
   cd Library_Management_System
```
3. Create the database (connected to `postgres`):
```bash
   psql -U postgres -d postgres -f 01_create_database.sql
```
4. Run the remaining files against the new database:
```bash
   psql -U postgres -d library_management -f 02_ddl.sql
   psql -U postgres -d library_management -f 03_dml.sql
   psql -U postgres -d library_management -f 04_dql.sql
```

Alternatively, open each file in **pgAdmin**'s Query Tool, making sure the correct
database is selected (`postgres` for file 1, `library_management` for the rest).

## 🔢 Correct SQL Execution Order

| Order | File | Connected database |
|---|---|---|
| 1 | `01_create_database.sql` | `postgres` |
| 2 | `02_ddl.sql` | `library_management` |
| 3 | `03_dml.sql` | `library_management` |
| 4 | `04_dql.sql` | `library_management` |

> `CREATE DATABASE` cannot run inside a transaction block or together with other
> statements in some tools, so it must be executed separately first.

## ✨ Sample Features

- Track multiple physical copies of each book with statuses (Available, Issued, Lost, Damaged).
- Support multiple authors per book via a many-to-many table.
- Prevent a copy from being loaned twice at the same time (partial unique index).
- Validate dates (`due_date >= issue_date`, `return_date >= issue_date`).
- Reserve books for members (Pending, Fulfilled, Cancelled).
- Manage fines with paid/unpaid status and consistent paid dates.
- Calculate overdue days and fines (Rs. 5.00 per day).
- List available books, currently issued books, overdue loans, and book counts per category.

## 🛠 Corrections Made to the Provided Code

The original code was copied from a document, so some formatting damage had to be fixed.
**No table, column, constraint, sample value, or query logic was changed.**

1. **Scrambled `INSERT INTO books`**: the first two book rows appeared before the
   `INSERT INTO books(...) VALUES` line, which is invalid SQL. They were moved back
   into a single valid statement with all three rows in their original order.
2. **Stray page numbers** (6, 7, 8, 9, 10, 11, 12, 13) and section headings
   (`7.2`, `7.3`, `7.4`) that were pasted into the code were removed.
3. **Constraint summary table**: this was documentation rather than SQL, so it is
   not included in the SQL files.
4. **Code was split by SQL category** (DDL, DML, DQL). The return-book `UPDATE`
   statements, originally placed with the queries, now live in `03_dml.sql`.

## 📝 Notes

- Because `03_dml.sql` returns loan 1 (`return_date = CURRENT_DATE`), there are no
  active loans afterwards, so queries 2, 3, and 5 in `04_dql.sql` return no rows
  with the sample data. To see output, skip the "return a book" updates (B2 and B3)
  or insert additional loans.
- The sample loan is due in 14 days, so it would not be overdue in any case.

## ✅ Conclusion

This project shows how a library can be modeled in PostgreSQL with a clean,
normalized schema and strong data integrity rules. It covers the core SQL
categories (DDL, DML, DQL) and can be extended with triggers, stored functions,
or an application front end.
