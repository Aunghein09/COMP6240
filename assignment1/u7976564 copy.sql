--------------------------------------------------------------------------------
-- COMP2400/COMP6240 SQL Assignment S1 2026
-- Please write your UID here: u1234567
-- Please enter your SQL queries for each of Questions 1-9 below the
-- corresponding comment line below, and leave those comment lines in
-- place.
--------------------------------------------------------------------------------

-- Q1
SELECT
    COUNT(*) AS music_contributing_crew
FROM
    crew
WHERE
    contribution = 'Music';


-- Q2
SELECT
    COUNT(DISTINCT (title,production_year)) AS movies_restricted_in_chile_count
FROM
    restriction
WHERE
    country = 'Chile';


-- Q3



-- Q4



-- Q5



-- Q6



-- Q7



-- Q8



-- Q9

