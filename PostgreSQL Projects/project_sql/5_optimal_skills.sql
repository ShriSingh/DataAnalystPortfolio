/*
Question: What are the most optimal skills to learn (aka it's in 
high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries 
for Data Analyst roles
- Concentrates on remote position with specified salaries
- Why? Targets skills that offer job security(high demand) and financial
benefits(high salary), offering strategic insights for career development
in data analysis
*/
WITH skills_demand AS (
    SELECT
        skills.skill_id,
        skills.skills,
        COUNT(skills_to_jobs.job_id) AS demand_count
    FROM job_postings_fact job_posts
    INNER JOIN skills_job_dim skills_to_jobs
            ON job_posts.job_id = skills_to_jobs.job_id
    INNER JOIN skills_dim skills
        ON skills_to_jobs.skill_id = skills.skill_id
    WHERE
        job_posts.job_title_short = 'Data Analyst' AND
        job_posts.salary_year_avg IS NOT NULL AND
        job_posts.job_work_from_home = TRUE
    GROUP BY skills.skill_id
), average_salary AS (
    SELECT
        skills.skill_id,
        skills.skills,
        ROUND(AVG(job_posts.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact job_posts
    INNER JOIN skills_job_dim skills_to_jobs
        ON job_posts.job_id = skills_to_jobs.job_id
    INNER JOIN skills_dim skills
        ON skills_to_jobs.skill_id = skills.skill_id
    WHERE
        job_posts.job_title_short = 'Data Analyst' AND
        job_posts.salary_year_avg IS NOT NULL AND
        job_posts.job_work_from_home = TRUE
    GROUP BY skills.skill_id
)

SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM skills_demand
    INNER JOIN average_salary
        ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY 
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
