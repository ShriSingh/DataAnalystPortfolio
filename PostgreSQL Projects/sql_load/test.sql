-- Checking to make sure all the data loaded in correctly
SELECT * FROM company_dim LIMIT 1000;

SELECT * FROM skills_dim LIMIT 1000;

SELECT * FROM job_postings_fact LIMIT 1000;

SELECT * FROM skills_job_dim LIMIT 1000;