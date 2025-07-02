/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for those roles
- Why? It provides a detailed look at which high-paying jobs demand certain skills,
helping job seekers understand which skills to develop that align with top 
salaries
*/
WITH top_paying_jobs AS (
    SELECT
        job_posts.job_id,
        job_posts.job_title,
        companies.name AS company_name,
        job_posts.salary_year_avg
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
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills.skills
FROM top_paying_jobs
INNER JOIN skills_job_dim skills_to_jobs
        ON top_paying_jobs.job_id = skills_to_jobs.job_id
INNER JOIN skills_dim skills
    ON skills_to_jobs.skill_id = skills.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC;