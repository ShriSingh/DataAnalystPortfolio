/*
'CASE' Expressions
- A expression in SQL to apply conditional logic
within your SQL queries
    - 'CASE': 
        - Begins the expression
    - 'WHEN':
        - Specifies the condition(s) to look at
    - 'THEN':
        - What to do when the condition is 'TRUE'
    - 'ELSE':
        - Optional
        - Provides output if none of the 'WHEN'
        conditions are met
    - 'END':
        - Concludes the 'CASE' expression
*/

/*
Label new column as follows:
    - 'Anywhere' jobs as 'Remote'
    - 'CA' jobs as 'Local'
    - Otherwise 'Onsite'
*/
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location LIKE '%CA' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY location_category;

/*
Label new column as follows:
    - 'Anywhere' jobs as 'Remote'
    - 'CA' jobs as 'Local'
    - Otherwise 'Onsite'
Filter out for all job titles
*/
SELECT
    COUNT(job_id) AS number_of_jobs,
    job_title_short,
    CASE 
        WHEN job_location = 'Anywhere' THEN 'Remote'
        WHEN job_location LIKE '%CA' THEN 'Local'
        ELSE 'Onsite'
    END AS location_category
FROM job_postings_fact
GROUP BY location_category, job_title_short;

/*
Practice Problem:
- Put salary into different buckets
- Define what's a high, standard, or low salary with our own conditions
- Only look at data analyst roles
- Order from highest to lowest
*/

/* Gives me the salary range
SELECT salary_year_avg 
FROM job_postings_fact 
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC;
*/
SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg <= 70000 THEN 'Low Salary'
        WHEN salary_year_avg <= 150000 THEN 'Standard Salary'
        ELSE 'High Salary'
    END AS salary_buckets
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY salary_buckets
ORDER BY salary_buckets DESC;

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN salary_year_avg <= 75000 THEN 'Low Salary'
        WHEN salary_year_avg <= 175000 THEN 'Standard Salary'
        ELSE 'High Salary'
    END AS salary_buckets
FROM job_postings_fact
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY salary_buckets
ORDER BY salary_buckets DESC;
