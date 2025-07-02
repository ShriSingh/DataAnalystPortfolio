/*
Practice Problem:
What are the most in-demand skills for data analysts?
- Join job postings to inner join table similar to query 2
- Identify the top 5 in-demand skills for a job data analyst
- Focus on all job postings
- Why? Retrieves the top 5 skills with the highest demand in the
job market, providing insights into the most valuable skills job seekers
*/
SELECT
    skills.skills,
    COUNT(skills_to_jobs.job_id) AS demand_count
FROM job_postings_fact job_posts
INNER JOIN skills_job_dim skills_to_jobs
        ON job_posts.job_id = skills_to_jobs.job_id
INNER JOIN skills_dim skills
    ON skills_to_jobs.skill_id = skills.skill_id
WHERE
    job_posts.job_title_short = 'Data Analyst' AND
    job_posts.job_work_from_home = TRUE
GROUP BY skills.skills
ORDER BY demand_count DESC
LIMIT 5;