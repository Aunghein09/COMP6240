--------------------------------------------------------------------------------
-- COMP2400/COMP6240 SQL Assignment S1 2026
-- Please write your UID here: u1234567
-- Please enter your SQL queries for each of Questions 1-9 below the
-- corresponding comment line below, and leave those comment lines in
-- place.
--------------------------------------------------------------------------------

-- Q1
SELECT
    COUNT(DISTINCT id) AS music_contributing_crew
FROM
    crew
WHERE
    contribution ILIKE '%music%';


-- Q2
SELECT
    COUNT(DISTINCT (title,production_year)) AS movies_restricted_in_chile_count
FROM
    restriction
WHERE
    country = 'Chile';


-- Q3
SELECT 
    DISTINCT title,production_year
FROM 
    movie
WHERE
    (title,production_year) 
    NOT IN (
           SELECT
                DISTINCT title,production_year 
            FROM
                MOVIE_AWARD
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                CREW_AWARD
        UNION  
            SELECT
                DISTINCT title,production_year 
            FROM
                DIRECTOR_AWARD
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                WRITER_AWARD
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                ACTOR_AWARD
    );


 
-- Q4
WITH popular_movies AS (
    SELECT
        title,production_year, count(*) AS award_count
    FROM
        MOVIE_AWARD
    GROUP BY
        title,production_year 
    HAVING 
        count(*) > 3
)
SELECT
    count(DISTINCT id) AS popular_directors_count
FROM
    director join popular_movies USING (title,production_year);

-- Q5

SELECT DISTINCT first_name, last_name, title, production_year
FROM
    PERSON JOIN
            (SELECT
                title, production_year, id, COUNT(distinct scene_no) AS scene_count
            FROM
                ROLE JOIN APPEARANCE USING (title,production_year,description)
            GROUP BY
                id,title,production_year
            HAVING
                COUNT(distinct scene_no) >= 6
            ) AS popular_actors
    USING (id);

-- Q6
(SELECT d.id AS director_id
FROM director d LEFT JOIN crew c USING (title, production_year)
GROUP BY title, production_year, d.id
HAVING COUNT(DISTINCT c.id) < 3)
INTERSECT
(SELECT
    DISTINCT id AS director_id
FROM
    MOVIE_AWARD JOIN DIRECTOR USING (title, production_year)
WHERE
    result ILIKE '%won%');

-- Q7
SELECT DISTINCT first_name, last_name
FROM director JOIN person USING (id)
WHERE production_year > 1999;



-- Q8
SELECT DISTINCT title, production_year
FROM actor_award
WHERE production_year = year_of_award;


-- Q9
-- WITH co_worked_movies AS (
--     SELECT c1.id AS crew_id_1, c2.id AS crew_id_2, count(DISTINCT (c1.title, c1.production_year)) AS co_worked_movies_count
--     FROM crew c1 JOIN crew c2 USING (title, production_year)
--     WHERE c1.id != c2.id
--     GROUP BY c1.id, c2.id
-- )
-- SELECT DISTINCT first_name, last_name
-- FROM person JOIN co_worked_movies ON person.id = co_worked_movies.crew_id_1
-- WHERE co_worked_movies_count = (SELECT MAX(co_worked_movies_count) FROM co_worked_movies);
WITH cocrew_counts AS (
    SELECT c1.id, COUNT(DISTINCT c2.id) AS cocrew_count
    FROM crew c1
    JOIN crew c2 USING (title, production_year)
    WHERE c1.id <> c2.id
    GROUP BY c1.id
)
SELECT DISTINCT p.first_name, p.last_name
FROM person p
JOIN cocrew_counts cc USING (id)
WHERE cc.cocrew_count = (SELECT MAX(cocrew_count) FROM cocrew_counts);