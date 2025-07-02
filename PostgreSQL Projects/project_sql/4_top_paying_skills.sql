/*
Question: What are the top skills based on salary?
- Look at the average salary associated with each skill for Data
Analyst positions
- Focuses on role with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data
Analysts and helps identify the most financially rewarding skills to
acquire or improve?
*/
SELECT
    skills.skills,
    ROUND(AVG(job_posts.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact job_posts
INNER JOIN skills_job_dim skills_to_jobs
        ON job_posts.job_id = skills_to_jobs.job_id
INNER JOIN skills_dim skills
    ON skills_to_jobs.skill_id = skills.skill_id
WHERE
    job_posts.job_title_short = 'Data Analyst' AND
    job_posts.salary_year_avg IS NOT NULL
GROUP BY skills.skills
ORDER BY avg_salary DESC
LIMIT 25;