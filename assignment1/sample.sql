-- Q1 How many unique persons are in the database?
SELECT 
    COUNT(id) 
FROM 
    person;

-- Q2 How many di erent  rst names of persons are there in database?
SELECT
    COUNT(DISTINCT first_name)
FROM
    person;

-- 3. List all distinct first names of persons in the database, along with for each the number
-- of persons that have that first name, ordered by that number.
SELECT 
    first_name, COUNT(first_name) count
FROM 
    person
GROUP BY 
    first_name
ORDER BY
    count asc;

-- 4. How many persons share the most common first name?

SELECT max(count)
FROM (SELECT 
    first_name, COUNT(first_name) count
    FROM 
        person
    GROUP BY 
        first_name
    ORDER BY
        count asc) AS pf_count;


-- 5. What is the most common first name?
SELECT first_name
FROM (SELECT 
    first_name, COUNT(first_name) count
    FROM 
        person
    GROUP BY 
        first_name) AS pf_count
WHERE count = (SELECT  max(count) FROM (SELECT 
    first_name, COUNT(first_name) count
    FROM 
        person
    GROUP BY 
        first_name) AS pf_count1)

WITH pf_count AS (
    SELECT 
        first_name, COUNT(first_name) count
    FROM 
        person
    GROUP BY 
        first_name)
select first_name
FROM
    pf_count
WHERE count = (
    SELECT
        MAX(count)
    FROM pf_count
);


-- 6. Find all the movies made in Australia. List the titles and production years of these Australian movies.

SELECT
    title, production_year
FROM
    movie
WHERE
    country = 'Australia';
-- 7. Which directors have directed crime movies (i.e., movies whose major genre is 'crime')?
-- List the directors' first and last names, and the titles and production years of these
-- crime movies.
SELECT 
    p.first_name, p.last_name, m.title, m.production_year
FROM
    person p
JOIN
    director d ON p.id = d.id
JOIN
    movie m ON d.title = m.title AND d.production_year = m.production_year
WHERE
    m.major_genre = 'crime';



-- 8. Which directors have directed crime movies (i.e., movies whose major genre is 'crime')?
-- List only the directors' first and last names, without repetition.
SELECT 
    DISTINCT p.first_name, p.last_name
FROM
    person p
JOIN
    director d ON p.id = d.id
JOIN
    movie m ON d.title = m.title AND d.production_year = m.production_year
WHERE
    m.major_genre = 'crime';

-- 9. List all movies (title and production year) for which any award, of any kind, has been
-- won, along with the total number of awards won for each movie, ordered by the number
-- of awards (most award-winning movie first).
SELECT 
    title, production_year, count(*) number_of_awards 
FROM 
    movie_award 
WHERE
    result = 'won' 
GROUP BY 
    title,production_year 
ORDER BY 
    number_of_awards DESC ;

SELECT
    title,
    production_year,
    total_awards
FROM (
    SELECT
        movie.title,
        movie.production_year,
        (
            SELECT COUNT(*)
            FROM movie_award
            WHERE movie.title = movie_award.title
                AND movie.production_year = movie_award.production_year
                AND lower(movie_award.result) = 'won'
        ) +
        (
            SELECT COUNT(*)
            FROM actor_award
            WHERE movie.title = actor_award.title
                AND movie.production_year = actor_award.production_year
                AND lower(actor_award.result) = 'won'
        ) +
        (
            SELECT COUNT(*)
            FROM crew_award
            WHERE movie.title = crew_award.title
                AND movie.production_year = crew_award.production_year
                AND lower(crew_award.result) = 'won'
        ) +
        (
            SELECT COUNT(*)
            FROM director_award
            WHERE movie.title = director_award.title
                AND movie.production_year = director_award.production_year
                AND lower(director_award.result) = 'won'
        ) +
        (
            SELECT COUNT(*)
            FROM writer_award
            WHERE movie.title = writer_award.title
                AND movie.production_year = writer_award.production_year
                AND lower(writer_award.result) = 'won'
        ) AS total_awards
    FROM movie
) AS award_totals
WHERE total_awards > 0
ORDER BY total_awards DESC;

-- 10. List all movies (title and production year) that were written and directed by one (and
-- only one!) person.
SELECT
    w.title,
    w.production_year
FROM
    writer w
JOIN
    director d ON w.title = d.title
    AND w.production_year = d.production_year
    AND w.id = d.id
GROUP BY
    w.title, w.production_year
HAVING
    COUNT(*) = 1;

SELECT
    w.title,
    w.production_year
FROM
    writer w
JOIN
    director d USING (id, title, production_year)
WHERE
    (
        SELECT COUNT(*)
        FROM writer AS w2
        WHERE w2.title = w.title
            AND w2.production_year = w.production_year
    ) = 1
    AND (
        SELECT COUNT(*)
        FROM director AS d2
        WHERE d2.title = d.title
            AND d2.production_year = d.production_year
    ) = 1;


    
-- 11. List all movies (title and production year) that had an 'R' restriction in the USA but
-- did not have an 'R' restriction in Australia.
SELECT
    title,
    production_year
FROM 
    restriction
WHERE
    country = 'USA' AND description = 'R'
    AND (title, production_year) NOT IN (
        SELECT title, production_year
        FROM restriction
        WHERE country = 'Australia' AND description = 'R');

SELECT
    r1.title,
    r1.production_year
FROM
    restriction AS r1
JOIN
    restriction AS r2 USING (title, production_year)
WHERE
    r1.country = 'USA'
    AND r1.description = 'R'
    AND r2.country = 'Australia'
    AND r2.description <> 'R'
UNION
SELECT
    r1.title,
    r1.production_year
FROM
    restriction AS r1
WHERE
    r1.country = 'USA'
    AND r1.description = 'R'
    AND NOT EXISTS (
        SELECT *
        FROM restriction AS r2
        WHERE r1.title = r2.title
            AND r1.production_year = r2.production_year
            AND r2.country = 'Australia'
    );

        

-- 12. What is the maximum total number of persons who worked (in any capacity, i.e., either
-- actor, crew, director or writer) on any movie?
-- 13. Find all the writers who have only written movies with at least one other writer (i.e.,
-- have never written a movie on their own). List their ids, first and last names.