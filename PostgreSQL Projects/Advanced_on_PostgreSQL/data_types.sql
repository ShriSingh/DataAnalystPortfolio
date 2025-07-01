/*
Common Data Types
- INT
    - Numeric Integer
    - An integer value: 123
    - A whole number
    - Range: -2,147,483,648 to 2,147,483,647 for regular INT(4 bytes)
- VARCHAR
    - A variable-length string(where 'n' is the maximum length):
        - E.g.:'Hello' with VARCHAR(10)
    - Provides a maximum character limit but can store strings of any
    length up to that limit
- TEXT
    - A string of characters
        - E.g.: 'Hello World!'
    - Stores variable-length strings with unlimited length
    - Often used for stroing long-form text that doesn't fit within the
    size constraints of VARCHAR
- BOOLEAN
    - Represents a logical entity that can be either TRUE or FALSE or NULL
    - Suitable for storing true/false values
- DATE
    - A specific date without time
        - E.g.: 2024-06-29
    - Format: YYYY-MM-DD
- TIMESTAMP
    - A specific data without time zone
        - E.g.: 2024-06-29 14:30:00
    - Format: YYYY-MM-DD HH:MM:SS
        - Capable of including second depending on the precision
- TIMESTAMP WITH TIME ZONE
    - A specific date and time with time zone information
        - E.g.: 2024-06-29 14:30:00+02
    - Adjusts stored time based on the time zone
    - Useful for applications requiring time zone awareness
- NUMERIC(precision, scale)
    - A precise number with fixed decimal points
    - Precision
        - Total number of digits
    - Scale
        - Number of fdigits to the right of the decimal point
    - E.g.: 123.456 -> NUMERIC(6, 3)

Data types specify the epected format of a value
- Need to be specified for data integrity to ensure only the correct
data is stored in a column
- Help databases process data more quickly and store it with less space
*/

CREATE TABLE job_applied (
    job_id INT,
    application_sent_date DATE,
    custom_resume BOOLEAN,
    resume_file_name VARCHAR(255),
    cover_letter_sent BOOLEAN,
    cover_letter_file_name VARCHAR(255),
    STATUS VARCHAR(50)
)

SELECT * FROM job_applied;

DROP TABLE job_applied;
