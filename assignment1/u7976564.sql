--------------------------------------------------------------------------------
-- COMP2400/COMP6240 SQL Assignment S1 2026
-- Please write your UID here: u7976564
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
    title,production_year
FROM 
    movie
WHERE
    (title,production_year) 
    NOT IN (
           SELECT
                DISTINCT title,production_year 
            FROM
                movie_award
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                crew_award
        UNION  
            SELECT
                DISTINCT title,production_year 
            FROM
                director_award
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                writer_award
        UNION
            SELECT
                DISTINCT title,production_year 
            FROM
                actor_award
    );


-- Q4

WITH popular_movies AS (
    SELECT
        title,production_year, count(*) AS award_count
    FROM
        movie_award
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
    person JOIN
            (SELECT
                title, production_year, id, COUNT(distinct scene_no) AS scene_count
            FROM
                role JOIN appearance USING (title,production_year,description)
            GROUP BY
                id,title,production_year
            HAVING
                COUNT(distinct scene_no) >= 6
            ) AS popular_actors
    USING (id);


-- Q6

SELECT 
    DISTINCT d.id AS director_id
FROM 
    director d
JOIN movie_award ma
  ON d.title = ma.title
    AND d.production_year = ma.production_year
WHERE ma.result ILIKE '%won%'
  AND (
      SELECT 
        COUNT(DISTINCT c.id)
      FROM 
        crew c
      WHERE c.title = d.title
        AND c.production_year = d.production_year
  ) < 3;


-- Q7

SELECT 
    DISTINCT first_name, last_name
FROM 
    director JOIN person USING (id)
WHERE 
    production_year > 1999;


-- Q8

SELECT 
    DISTINCT title, production_year
FROM 
    actor_award
WHERE 
    production_year = year_of_award;

-- Q9

WITH cocrew_counts AS (
    SELECT 
        c1.id, COUNT(DISTINCT c2.id) AS cocrew_count
    FROM crew c1
    LEFT JOIN crew c2
      ON c1.title = c2.title
     AND c1.production_year = c2.production_year
     AND c1.id <> c2.id
    GROUP BY c1.id
)
SELECT 
    DISTINCT p.first_name, p.last_name
FROM 
    person p JOIN cocrew_counts cc USING (id)
WHERE 
    cc.cocrew_count = (
    SELECT MAX(cocrew_count) FROM cocrew_counts
);