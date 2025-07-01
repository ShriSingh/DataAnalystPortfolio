/*
Subqueries and CTEs
- Used for organizing and simplifying complex queries
    - Helps break down the query into smaller, more manageable parts
- When to use which
    - Subqueries for simpler queries
    - CTEs for complex queries

Subqueries
- Query nested inside a larger query
- Can be used in several places in the main query
    - Can be used in 'SELECT', 'FROM', 'WHERE', and 'HAVING' clauses
- It's executed first, and the results are passed to the outer query
    - It's used when you want to perform a calculation before the main
    query can complete its calculation

CTE(Common Table Expression):
- Define a temporary result set that you can reference
    - Can reference within a 'SELECT', 'INSERT', 'UPDATE', or 'DELETE' statement
- Defined with 'WITH'
- Exists only during the execution of a query
- Can be referenced in the main query or other CTEs
*/

-- Selecting all columns of january_jobs thru a subquery
SELECT * 
FROM (
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
) AS january_jobs;

-- Select all columns of january_job thru a CTE
WITH january_jobs AS (
    SELECT * 
    FROM job_postings_fact 
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1
)
SELECT * FROM january_jobs;

-- Finding all the company that don't mention anything about degrees
-- on their job postings
SELECT 
    company_id,
    name AS company_name
FROM company_dim
WHERE company_id IN (
    SELECT
        company_id
    FROM job_postings_fact
    WHERE job_no_degree_mention = TRUE
    ORDER BY company_id
);

-- Find the companies that have the most job openings
-- Get the total number of job postings per company id ('job_posting_fact')
-- Returns the total number of jobs with the company name ('company_dim')
WITH company_job_count AS (
    SELECT 
        company_id, -- Displays multiple # because each company has multiple job postings
        COUNT(*) AS total_jobs
    FROM job_postings_fact
    GROUP BY company_id
)
-- SELECT * FROM company_job_count
SELECT 
    companies.name AS company_name,
    company_job_count.total_jobs
FROM company_dim companies
LEFT JOIN company_job_count 
    ON companies.company_id = company_job_count.company_id
ORDER BY total_jobs DESC;

/*
Practice Problem:
Identify the top 5 skills that are most frequently mentioned in job
postings. Use a subquery to find the skills IDs with the highest counts
in the 'skills_job_dim' table and then join this results with the 
'skills_dim' table to get the skill names.
*/

-- SELECT * FROM skills_job_dim LIMIT 50;
-- SELECT * FROM skills_dim LIMIT 50;

SELECT
    skill_name,
    skill_count
FROM (
    SELECT 
        skills.skills AS skill_name,
        COUNT(skills_to_jobs.skill_id) AS skill_count
    FROM skills_job_dim skills_to_jobs
    INNER JOIN skills_dim skills
        ON skills_to_jobs.skill_id = skills.skill_id
    GROUP BY skills.skills
    ORDER BY skill_count DESC
    LIMIT 5
) AS top_5_skills;



/*
Practice Problem:
Determine the size category('Small', 'Medium', or 'Large') for each company
by first identifying the number of job postings they have. Use a subquery to
calculate the total job postings per company.
    - Small: Less than 10 job postings
    - Medium: Number of job postings is between 10 & 50
    - Large: More than 50 job postings
Implement a subquery to aggregate job counts per company before classifying
them based on size.
*/

-- SELECT * FROM company_dim LIMIT 500;
-- SELECT * FROM job_postings_fact LIMIT 500;

SELECT
    company_name,
    CASE
        WHEN job_postings < 10 THEN 'Small'
        WHEN job_postings <= 50 THEN 'Medium'
        ELSE 'Large'
    END AS company_size
FROM (
    SELECT
        companies.name AS company_name,
        COUNT(job_posts.job_id) AS job_postings
    FROM job_postings_fact job_posts
        LEFT JOIN company_dim companies
            ON job_posts.company_id = companies.company_id
    GROUP BY companies.name
) AS company_size_rankings;

/*
Practice Problem:
Find the count of the number of remote job postings per skill
- Display the top 5 skills by their demand in remote jobs
- Include skill ID, name, and count of postings requiring the skill
*/
WITH remote_job_skills AS (
    SELECT 
        skills_to_job.skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_posts
            ON skills_to_job.job_id = job_posts.job_id
    WHERE
        job_posts.job_work_from_home = TRUE
    GROUP BY skills_to_job.skill_id
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
    INNER JOIN skills_dim AS skills
        ON remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;


WITH remote_job_skills AS (
    SELECT 
        skills_to_job.skill_id,
        COUNT(*) AS skill_count
    FROM skills_job_dim AS skills_to_job
        INNER JOIN job_postings_fact AS job_posts
            ON skills_to_job.job_id = job_posts.job_id
    WHERE
        job_posts.job_work_from_home = TRUE AND
        job_posts.job_title_short = 'Data Scientist' -- Top 5 skill for a job
    GROUP BY skills_to_job.skill_id
)

SELECT 
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
    INNER JOIN skills_dim AS skills
        ON remote_job_skills.skill_id = skills.skill_id
ORDER BY skill_count DESC
LIMIT 5;