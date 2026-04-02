-- 1. List the number of crews that made a contribution to the music in a movie. List that
-- number.
SELECT COUNT(DISTINCT id)
FROM crew
WHERE contribution ILIKE '%music%';

SELECT COUNT(*) AS num_music_crews
FROM CREW
WHERE contribution ILIKE '%music%';

-- 2. Count the number of movies that have restrictions from Chile, i.e., the restriction country
-- is Chile. List that number.
SELECT COUNT(DISTINCT (title, production_year))
FROM restriction
WHERE country = 'Chile';

SELECT COUNT(*) AS num_movies
FROM (
    SELECT DISTINCT title, production_year
    FROM RESTRICTION
    WHERE country = 'Chile'
) AS distinct_movies;

-- 3. List all movies’ title and production year that have never been nominated for an award.
-- An award here can be movie/crew/director/writer/actor award. The query result should
SELECT DISTINCT m.title, m.production_year
FROM MOVIE m
WHERE NOT EXISTS (SELECT 1 FROM MOVIE_AWARD    ma WHERE ma.title = m.title AND ma.production_year = m.production_year)
  AND NOT EXISTS (SELECT 1 FROM CREW_AWARD     ca WHERE ca.title = m.title AND ca.production_year = m.production_year)
  AND NOT EXISTS (SELECT 1 FROM DIRECTOR_AWARD da WHERE da.title = m.title AND da.production_year = m.production_year)
  AND NOT EXISTS (SELECT 1 FROM WRITER_AWARD   wa WHERE wa.title = m.title AND wa.production_year = m.production_year)
  AND NOT EXISTS (SELECT 1 FROM ACTOR_AWARD    aa WHERE aa.title = m.title AND aa.production_year = m.production_year);


-- have two columns: the movie title, production year, and contains no duplicates.
SELECT DISTINCT title, production_year
FROM movie
WHERE (title, production_year) NOT IN (
    SELECT title, production_year FROM movie_award
    UNION
    SELECT title, production_year FROM crew_award
    UNION
    SELECT title, production_year FROM director_award
    UNION
    SELECT title, production_year FROM writer_award
    UNION
    SELECT title, production_year FROM actor_award
);




-- 4. We say a movie is a popular movie if it has been nominated for a movie award more than
-- three times. Count the number of directors who have directed at least one popular movie.
WITH popular_movies AS (
    SELECT title, production_year
    FROM movie_award
    GROUP BY title, production_year
    HAVING COUNT(*) > 3
)
SELECT COUNT(DISTINCT id) AS popular_directors_count
FROM director
JOIN popular_movies USING (title, production_year);


SELECT COUNT(DISTINCT d.id) AS num_directors
FROM DIRECTOR d
WHERE (d.title, d.production_year) IN (
    SELECT title, production_year
    FROM MOVIE_AWARD
    GROUP BY title, production_year
    HAVING COUNT(*) > 3
);
-- List that number. The term movie award here refers only to the awards listed in the
-- MOVIE AWARD table, not to those in other award tables (e.g., ACTOR AWARD).
-- 5. List all actors’ first and last names who have appeared in at least six different scenes
-- within one movie and the title and production year of that movie. The query result
-- should have four columns, i.e., the actors’ first and last names, and the movies’ title and
-- production year, and contains no duplicates.

SELECT DISTINCT p.first_name, p.last_name, r.title, r.production_year
FROM person p
JOIN role r ON p.id = r.id
JOIN appearance a USING (title, production_year, description)
GROUP BY p.id, p.first_name, p.last_name, r.title, r.production_year
HAVING COUNT(DISTINCT a.scene_no) >= 6;

SELECT DISTINCT p.first_name, p.last_name, r.title, r.production_year
FROM APPEARANCE a
JOIN ROLE r
    ON a.title = r.title
    AND a.production_year = r.production_year
    AND a.description = r.description
JOIN PERSON p ON r.id = p.id
GROUP BY r.id, p.first_name, p.last_name, r.title, r.production_year
HAVING COUNT(DISTINCT a.scene_no) >= 6;

-- 6 .List the ids of all directors who have directed at least one movie that has won at least
-- one movie award and has fewer than three crews. The query result should have a single
-- column, i.e., the directors’ ids, and contain no duplicates. The term movie award here
-- refers only to the awards listed in the MOVIE AWARD table, not to those in other award
-- tables (e.g., ACTOR AWARD).

WITH won_movies AS (
    SELECT DISTINCT title, production_year
    FROM movie_award
    WHERE LOWER(result) = 'won'
),
crew_counts AS (
    SELECT title, production_year, COUNT(*) AS crew_count
    FROM crew
    GROUP BY title, production_year
)
SELECT DISTINCT d.id
FROM director d
JOIN won_movies w USING (title, production_year)
LEFT JOIN crew_counts cc USING (title, production_year)
WHERE COALESCE(cc.crew_count, 0) < 3;

-- 7. List the directors’ first and last names who have directed at least one movie produced
-- after year 1999 (NOT including 1999). The query result should have two columns: the
-- first is directors’ first name, the second is directors’ last name, and no duplicates.

SELECT DISTINCT p.first_name, p.last_name
FROM person p
JOIN director d USING (id)
WHERE d.production_year > 1999;


-- 8. List the title and production year of all movies that were nominated for the actor award
-- in the same year they were produced. The query results should have two columns: the
-- movie title, production year, and no duplicates.
SELECT DISTINCT aa.title, aa.production_year
FROM ACTOR_AWARD aa
WHERE aa.year_of_award = aa.production_year;

-- 9. We say that two persons are co-crews if they have appeared as a crew in the same movie.
-- List the first and last names of all crews that have the highest number of distinct cocrews.
-- The query result should have two columns: the first column is crews’ first names,
-- the second column is crew’s last names, and contains no duplicates.

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


    SELECT c1.id, c2.id
    FROM crew c1
    JOIN crew c2 USING (title, production_year)
    WHERE c1.id <> c2.id