/*
Handling Dates

Date Functions in SQL:
- Used to perform operations on date and time values
    - ::DATE
        - Converts to a date format by removing the time portion
        - '::'
            - Used for casting
                - Converting a value from one data type to another
        - '::DATE'
            - Convert this value into a date format
            - Date Format: YYYY-MM-DD
            - Timestamp Format: YYYY-MM-DD HH;MM:SS
    - AT TIME ZONE
        - Converts a timestamp to a specified time zone
        - Can be used on timestamps with or without time zone info
            - TIMESTAMP
                - A specific date  time without timezone
                - Format: YYYY-MM-DD HH:MI:SS
            - TIMESTAMP WITH TIME ZONE
                - A specific date and time with time zone info
                - Stored as UTC
                - Displayed per query's or system's time zone
                - Format: YYYY-MM-DD HH:MI:SS+00:00
                - 'AT TIME ZONE' converts UTC to the specified time zone correctly
    - EXTRACT
        - Gets specific date parts from a date/time value
            - E.g.: year, month, day

'job_posted_date'
- The timestamp 'YYYY-MM-DD HH:MM:SS' of when a job was posted in UTC
    - This column will be our focus during this section
*/

SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;

-- Selecting a string value of a date
SELECT '2023-02-19';

-- Casting a string value into a date
SELECT '2023-02-19'::DATE;

-- Casting various strings into different data types
SELECT 
    '2023-02-19'::DATE,
    '123'::INTEGER,
    'TRUE'::BOOLEAN,
    '3.14'::REAL;

-- Getting the title, location, and date
SELECT
    job_posts.job_title_short AS title,
    job_posts.job_location AS location,
    job_posts.job_posted_date AS DATE
FROM job_postings_fact job_posts;

-- Extracting the date value only(without timestamp)
SELECT
    job_posts.job_title_short AS title,
    job_posts.job_location AS location,
    job_posts.job_posted_date::DATE AS DATE
FROM job_postings_fact job_posts;

-- Checking out the time zone of the dates
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AS date_time
FROM job_postings_fact
LIMIT 5;

-- Converting time zone from 'UTC' to 'PST'
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'PST' AS date_time
FROM job_postings_fact
LIMIT 5;

-- Getting month from the date
SELECT
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'PST' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM job_postings_fact
LIMIT 5;

-- Looking at how job_postings are trending from month to month
-- For 'Data Analyst' role
SELECT
    COUNT(job_id) AS job_posted_count,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
WHERE 
    job_title_short = 'Data Analyst'
GROUP BY month
ORDER BY job_posted_count DESC;

/*
Practice Problem 1:
Write a query to find the average salary both yearly('salary_year_avg')
and hourly('salary_hour_avg') for job postings were posted after June 1, 2023.
Group the results by job schedule type.
*/

-- SELECT * FROM job_postings_fact LIMIT 50;

SELECT
    AVG(salary_year_avg) AS "Average Yearly Salary",
    AVG(salary_hour_avg) AS "Average Hourly Salary",
    job_schedule_type
FROM job_postings_fact
WHERE job_posted_date::DATE > '2023-06-01'
GROUP BY job_schedule_type;

/*
Practice Problem 2:
Write a query to count the number of job postings for each month in 2023,
adjusting the 'job_posted_date' to be in 'America/New York' time zone before
extracting the month. Assume the 'job_posted_date' is stored in UTC. Group
by and order by the month.
*/

-- SELECT job_posted_date AT TIME ZONE 'UTC' FROM job_postings_fact LIMIT 5;

SELECT
    COUNT(job_id) AS job_postings_count,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EDT' AS date_time,
    EXTRACT(MONTH FROM job_posted_date) AS month
FROM job_postings_fact
GROUP BY month, date_time
ORDER BY month;

/*
Practice Problem 3:
Write a query to find companies(include company 'name') that have posted 
jobs offering health insurance, where these postings were made in the second
quarter of 2023. Use date extracting to filter by quarter.
*/

-- SELECT * FROM company_dim LIMIT 50;
-- SELECT * FROM job_postings_fact LIMIT 50;

SELECT
    companies.name
FROM job_postings_fact job_posts
INNER JOIN company_dim companies
    ON job_posts.company_id = companies.company_id
WHERE 
    EXTRACT(QUARTER FROM job_posts.job_posted_date) = 2 AND
    EXTRACT(YEAR FROM job_posts.job_posted_date) = 2023 AND
    job_posts.job_health_insurance = TRUE;

