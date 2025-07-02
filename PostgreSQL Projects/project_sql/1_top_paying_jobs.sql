/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Analyst roles that are available remotely.
- Focuses on job postings with specified salaries (remove nulls).
- Why? Highlight the top-paying opportunities for Data Analysts, offering
insights into employment opportunities.
*/
SELECT
    job_posts.job_id,
    job_posts.job_title,
    companies.name AS company_name,
    job_posts.job_location,
    job_posts.job_schedule_type,
    job_posts.salary_year_avg,
    job_posts.job_posted_date
FROM 
    job_postings_fact job_posts
LEFT JOIN 
    company_dim AS companies
        ON companies.company_id = job_posts.company_id
WHERE 
    job_posts.job_title_short = 'Data Analyst' AND
    job_posts.job_location = 'Anywhere' AND
    job_posts.salary_year_avg IS NOT NULL
ORDER BY
    job_posts.salary_year_avg DESC
LIMIT 10;