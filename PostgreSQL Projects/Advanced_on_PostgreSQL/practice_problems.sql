/* Practice Problem:
- Creating Tables from Other Tables
    - Create 23 tables:
        - Jan 2023 jobs
        - Feb 2023 jobs
        - Mar 2023 jobs
*/

-- Getting job postings only from january
SELECT * 
FROM job_postings_fact 
WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

-- Creating job postings 3 monthly tables
CREATE TABLE january_jobs AS
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE february_jobs AS
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

CREATE TABLE march_jobs AS
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;

SELECT job_posted_date FROM january_jobs;
SELECT job_posted_date FROM february_jobs;
SELECT job_posted_date FROM march_jobs;

DROP TABLE january_jobs;
DROP TABLE february_jobs;
DROP TABLE march_jobs;


