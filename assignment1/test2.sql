-- Q1: Number of crews that made a contribution to music in a movie
SELECT COUNT(DISTINCT id) AS count
FROM crew
WHERE LOWER(contribution) LIKE '%music%';

-- Q2: Number of movies with restrictions from Chile
SELECT COUNT(DISTINCT (title, production_year)) AS count
FROM restriction
WHERE country = 'Chile';

-- Q3: Movies never nominated for any award (not in any of the 5 award tables)
SELECT DISTINCT m.title, m.production_year
FROM movie m
WHERE NOT EXISTS (
    SELECT 1 FROM movie_award ma
    WHERE ma.title = m.title AND ma.production_year = m.production_year
)
AND NOT EXISTS (
    SELECT 1 FROM crew_award ca
    WHERE ca.title = m.title AND ca.production_year = m.production_year
)
AND NOT EXISTS (
    SELECT 1 FROM director_award da
    WHERE da.title = m.title AND da.production_year = m.production_year
)
AND NOT EXISTS (
    SELECT 1 FROM writer_award wa
    WHERE wa.title = m.title AND wa.production_year = m.production_year
)
AND NOT EXISTS (
    SELECT 1 FROM actor_award aa
    WHERE aa.title = m.title AND aa.production_year = m.production_year
);

-- Q4: Number of directors who directed at least one popular movie
-- (popular = nominated for movie award more than 3 times, i.e., >3 rows in MOVIE_AWARD)
SELECT COUNT(DISTINCT d.id) AS count
FROM director d
WHERE EXISTS (
    SELECT 1
    FROM movie_award ma
    WHERE ma.title = d.title AND ma.production_year = d.production_year
    GROUP BY ma.title, ma.production_year
    HAVING COUNT(*) > 3
);

-- Q5: Actors appearing in at least 6 different scenes within one movie
SELECT DISTINCT p.first_name, p.last_name, r.title, r.production_year
FROM role r
JOIN person p ON r.id = p.id
JOIN appearance a ON r.title = a.title
    AND r.production_year = a.production_year
    AND r.description = a.description
GROUP BY p.first_name, p.last_name, r.id, r.title, r.production_year
HAVING COUNT(DISTINCT a.scene_no) >= 6;

-- Q6: Directors who directed a movie that won at least one movie award and has fewer than 3 crews
SELECT DISTINCT d.id
FROM director d
WHERE EXISTS (
    SELECT 1 FROM movie_award ma
    WHERE ma.title = d.title AND ma.production_year = d.production_year
      AND LOWER(ma.result) = 'won'
)
AND (
    SELECT COUNT(*) FROM crew c
    WHERE c.title = d.title AND c.production_year = d.production_year
) < 3;

-- Q7: Directors who directed at least one movie produced after 1999
SELECT DISTINCT p.first_name, p.last_name
FROM director d
JOIN person p ON d.id = p.id
WHERE d.production_year > 1999;

-- Q8: Movies nominated for actor award in the same year they were produced
SELECT DISTINCT aa.title, aa.production_year
FROM actor_award aa
WHERE aa.year_of_award = aa.production_year;

-- Q9: Crews with the highest number of distinct co-crews
WITH co_crew_counts AS (
    SELECT c1.id, COUNT(DISTINCT c2.id) AS co_crew_count
    FROM crew c1
    JOIN crew c2 ON c1.title = c2.title
        AND c1.production_year = c2.production_year
        AND c1.id <> c2.id
    GROUP BY c1.id
)
SELECT DISTINCT p.first_name, p.last_name
FROM co_crew_counts cc
JOIN person p ON cc.id = p.id
WHERE cc.co_crew_count = (SELECT MAX(co_crew_count) FROM co_crew_counts);
