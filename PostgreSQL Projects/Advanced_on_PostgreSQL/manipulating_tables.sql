/*
Manipulating Tables

The following statements are used to mainpulate tables
- CREATE TABLE: Creates tables from scratch
- INSERT INTO: Adds columns (data) to your tables
- ALTER TABLE: Alters tables - adding, removing, changing
datatypes of columns
    - ADD: Adds columns
    - RENAME COLUMN: Renames columns
    - ALTER COLUMN: Changes the datatype of a column
    - DROP COLUMN: Deletes a column
- DROP TABLE: Deletes tables
    - Can be permanant(Dangerous)
- UPDATE TABLE: Modifies existing data in a table
    - SET: Specifies the column to be updated and the new value
    for that column
    - WHERE: Filters which rows to update based on a condition
*/

-- Creating 
CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    STATUS VARCHAR(50)
);

-- Checking if the table was created
SELECT * FROM job_applied;

-- Inserting some data in the table
INSERT INTO job_applied (
    job_id,
    application_sent_date,
    custom_resume,
    resume_file_name,
    cover_letter_sent,
    cover_letter_file_name,
    STATUS
) VALUES 
    (
        1,
        '2024-01-01',
        TRUE,
        'shriyansh_singh_resume.pdf',
        FALSE,
        NULL,
        'submitted'
    ),
    (
        2,
        '2024-01-07',
        TRUE,
        'shriyansh_singh_resume.pdf',
        TRUE,
        'shriyansh_singh_cover_letter.pdf',
        'submitted'
    ),
    (
        3,
        '2024-01-13',
        TRUE,
        'shriyansh_singh_resume.pdf',
        TRUE,
        'shriyansh_singh_cover_letter.pdf',
        'not submitted'
    ),
    (
        4,
        '2024-01-19',
        FALSE,
        NULL,
        TRUE,
        'shriyansh_singh_cover_letter.pdf',
        'not submitted'
    ),
    (
        5,
        '2024-01-19',
        TRUE,
        'shriyansh_singh_resume.pdf',
        TRUE,
        'shriyansh_singh_cover_letter.pdf',
        'submitted'
    );
    
-- Modifying job_applied table
ALTER TABLE job_applied 
ADD contact VARCHAR(50);

-- Modifying contact column in the job_applied table
UPDATE job_applied
SET contact = 'Surya Singh'
WHERE job_id = 1;

UPDATE job_applied
SET contact = 'Casey Comings'
WHERE job_id = 2;

UPDATE job_applied
SET contact = 'OMNIVISION Recruiting Team'
WHERE job_id = 3;

UPDATE job_applied
SET contact = 'Volvo Group Talent'
WHERE job_id = 4;

UPDATE job_applied
SET contact = 'NVIDIA HR'
WHERE job_id = 5;

-- Modifying the name of a column
ALTER TABLE job_applied
RENAME COLUMN contact TO contact_name;

-- Modifying the datatype of a column
ALTER TABLE job_applied
ALTER COLUMN contact_name TYPE TEXT;

-- Dropping a column 
ALTER TABLE job_applied
DROP COLUMN contact_name;

-- Dropping the table
DROP TABLE job_applied;
