/*
Union Operators:
    - UNION
        - Combines results from two or more 'SELECT' statements
        - They need to have the same amount of columns
            - The data type must match
        - Gets rid of duplicate rows
            - All rows are unique, unlike 'UNION ALL'
    - UNION ALL
        - Combine the result of two or more SELECT statements
        - They need to have the same amount of columns
            - The data type must match
        - Returns all rows, even duplicates(unlike 'UNION')
            - Mostly used to combine two tables together
*/

-- SELECT * FROM january_jobs;
-- SELECT * FROM february_jobs;
-- SELECT * FROM march_jobs;

-- Get jobs and companies from January
SELECT
    job_title_short,
    company_id,
    job_location
FROM january_jobs

-- UNION
UNION ALL

-- Get jobs and companies from February
SELECT
    job_title_short,
    company_id,
    job_location
FROM february_jobs

-- UNION
UNION ALL

-- Get jobs and companies from March
SELECT
    job_title_short,
    company_id,
    job_location
FROM march_jobs;

/*
Practice Problem:
Get the corresponding skill and skill type for each posting 
- Includes those without any skills
Look at the skills and the type for each job in the 1st quarter
that has a salary > $70,000
*/

-- SELECT * FROM january_jobs LIMIT 50;
-- SELECT * FROM skills_job_dim LIMIT 50;

WITH first_quarter_jobs AS (
    SELECT
        job_id,
        salary_year_avg
    FROM january_jobs

    UNION

    SELECT
        job_id,
        salary_year_avg
    FROM february_jobs

    UNION

    SELECT
        job_id,
        salary_year_avg
    FROM march_jobs
)

SELECT 
    jobs_posts.job_id,
    skills.skills,
    skills.type,
    jobs_posts.salary_year_avg
FROM first_quarter_jobs jobs_posts
    LEFT JOIN skills_job_dim jobs_to_skills
        ON jobs_posts.job_id = jobs_to_skills.job_id
    LEFT JOIN skills_dim skills
    ON skills.skill_id = jobs_to_skills.skill_id
WHERE jobs_posts.salary_year_avg > 70000

/*
Practice Problem:
Find jobs postings from the first quarter that have a salary 
greater than $70K
- Combine job posting tables from the first quarter of 2023(Jan-Mar)
- Gets jobs postings with an average yearly salary > $70,000
*/

SELECT
    job_title_short,
    job_location,
    job_via,
    job_posted_date::date,
    salary_year_avg
FROM (
    SELECT *
    FROM january_jobs
    UNION ALL
    SELECT *
    FROM february_jobs
    UNION ALL
    SELECT *
    FROM march_jobs
) AS quarter1_job_earnings
WHERE
    salary_year_avg > 70000 AND
    job_title_short = 'Data Analyst'
ORDER BY
    salary_year_avg DESC;
