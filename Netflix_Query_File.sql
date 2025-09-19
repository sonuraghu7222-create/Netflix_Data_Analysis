CREATE DATABASE Netflix;

USE Netflix;


DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix (
    show_id  	VARCHAR(50),
    type     	VARCHAR(50),
    title    	VARCHAR(300),
    director 	VARCHAR(500),
    cast     	VARCHAR(2000),
    country  	VARCHAR(200),
    date_added 	VARCHAR(100),
    release_year VARCHAR(10),
    rating 		VARCHAR(20),
    duration 	VARCHAR(50),
    listed_in 	VARCHAR(500),
    description TEXT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/netflix_titles.csv'
INTO TABLE netflix
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


-- Now let's Validate the data:


-- Check if all records imported successfully
SELECT COUNT(*) Total_Rows FROM netflix;

-- Check for any duplicates by show_id it should be unique:
SELECT show_id, COUNT(*) duplicate_records FROM netflix
GROUP BY show_id
HAVING COUNT(*) > 1;

-- Check for NULL or Missing Values
SELECT
SUM(CASE WHEN director IS NULL OR director = '' THEN 1 ELSE 0 END) AS missing_director,
SUM(CASE WHEN cast IS NULL OR cast = '' THEN 1 ELSE 0 END) AS missing_cast,
SUM(CASE WHEN country IS NULL OR country = '' THEN 1 ELSE 0 END) AS missing_country,
SUM(CASE WHEN date_added IS NULL OR date_added = '' THEN 1 ELSE 0 END) AS missing_date_added,
SUM(CASE WHEN rating IS NULL OR rating = '' THEN 1 ELSE 0 END) AS missing_rating
FROM netflix;

-- Check Distinct Categories
SELECT DISTINCT type FROM netflix;
SELECT DISTINCT rating FROM netflix;

-- Spot Outliers if any
SELECT DISTINCT release_year
FROM netflix
ORDER BY release_year;

-- As checked our data is good to go for further business problem analysis:

-- ==================================================================Problem Statements================================================================================

-- 1. Count The Number of Movies Vs TV Shows

SELECT type, COUNT(*) AS Total_Count FROM netflix
GROUP BY type;

-- 2. Find the most common rating for movies and TV shows

SELECT type, rating AS Most_co, total_rating_count
FROM (
SELECT type, rating, COUNT(*) AS total_rating_count,
RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM netflix
GROUP BY type, rating) AS ranked
Where ranking = 1;


-- 3. List all movies released in a specific year (e.g., 2020)

SELECT type, title, release_year FROM netflix
WHERE type = "Movie" AND release_year = 2020;


-- 4. Find the top 5 countries with the most content on Netflix

-- Since our country column has multiple countries seperated by ',' So first of all we have to seperate all the countries:
-- For this we will use Recursive CTE:

WITH RECURSIVE split_cte AS (
  -- Start with the original row
  SELECT 
      show_id,
      TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
      SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2) AS rest
  FROM netflix
  WHERE country IS NOT NULL AND country <> ''

  UNION ALL

  -- Recursively split remaining part
  SELECT 
      show_id,
      TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS country,
      SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
  FROM split_cte
  WHERE rest <> ''
)
-- Now we will list the top 5 countries as per total_content
SELECT country, COUNT(DISTINCT show_id) AS total_content
FROM split_cte
WHERE country <> ''
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;


-- 5. Identify the longest movie

SELECT title, duration FROM netflix
WHERE type = 'Movie' AND duration = ( SELECT MAX(duration) FROM netflix)
LIMIT 1;



-- 6. Find content added in the last 5 years
-- First of all we will convert the date_added column into proper date format since currently the dates are stored as 'September 25, 2021' VARCHAR in our date_added column

ALTER TABLE netflix ADD COLUMN date_added_new DATE;

SET SQL_SAFE_UPDATES = 0;

UPDATE netflix
SET date_added_new = str_to_date(date_added, '%M %d, %Y')
WHERE date_added IS NOT NULL AND date_added <> '';

ALTER TABLE netflix DROP COLUMN date_added;
ALTER TABLE netflix CHANGE date_added_new date_added DATE;

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM netflix;

SELECT * FROM netflix
WHERE date_added >= current_date() - INTERVAL 5 year;

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT show_id, type, title, director FROM netflix
WHERE director LIKE '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons

SELECT title, type, duration FROM netflix
WHERE type = 'TV Show' AND duration > 5;

-- OR

SELECT title, type, duration FROM netflix
WHERE type = 'TV Show' AND substring_index(duration , ' ', 1) > 5;
 
-- 9. Count the number of content items in each genre

WITH RECURSIVE split_listed_in AS (
SELECT
		show_id,
        TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) AS listed_in,
        SUBSTRING(listed_in, length(SUBSTRING_INDEX(listed_in, ',', 1)) +2) as rest
        FROM netflix
        WHERE listed_in IS NOT NULL AND listed_in <> ''
        
UNION ALL

SELECT
		show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS listed_in,
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) +2)
        from split_listed_in
        WHERE rest IS NOT NULL AND rest <> ''
)
SELECT listed_in, COUNT(*) Total_Content FROM split_listed_in
GROUP BY listed_in
ORDER BY Total_Content DESC;


/* -- 10. Find each year and the numbers of content release in that year in India on netflix,
	return top 5 year with highest avg monthly content release!	*/
    
    
    SELECT release_year, COUNT(show_id) AS Total_content_released, ROUND(COUNT(show_id)/12, 0) AS avg_content_per_month FROM netflix
    WHERE country LIKE '%India%'
    GROUP BY release_year
    ORDER BY avg_content_per_month DESC
    LIMIT 5;
    

-- 11. List all movies that are documentaries

SELECT title, type, listed_in FROM netflix
WHERE type = 'Movie' AND listed_in LIKE '%Documentaries%';


-- 12. Find all content without a director
SELECT show_id, director FROM netflix
WHERE director IS NULL OR director = '';

-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT COUNT(*) AS total_movies FROM netflix
WHERE type = 'Movie' AND cast LIKE '%Salman Khan%' AND date_added >= current_date() - Interval 10 year;

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

WITH RECURSIVE split_cast AS (
    SELECT
        type,
        country,
        TRIM(SUBSTRING_INDEX(cast, ',', 1)) AS actor_name,
        SUBSTRING(cast, LENGTH(SUBSTRING_INDEX(cast, ',', 1)) + 2) AS rest
    FROM netflix
    WHERE cast IS NOT NULL 
      AND cast <> ''
      AND type = 'Movie'
      AND country LIKE '%India%'

    UNION ALL

    SELECT
        type,
        country,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS actor_name,
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2) AS rest
    FROM split_cast
    WHERE rest IS NOT NULL AND rest <> ''
)

SELECT actor_name, COUNT(*) AS total_movies
FROM split_cast
GROUP BY actor_name
ORDER BY total_movies DESC
LIMIT 10;


/* 15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
	the description field. Label content containing these keywords as 'Bad' and all other 
	content as 'Good'. Count how many items fall into each category.
*/

SELECT Label, COUNT(*) AS total_items
FROM (
    SELECT 
        CASE 
            WHEN LOWER(description) LIKE '%kill%' 
              OR LOWER(description) LIKE '%violence%' 
            THEN 'Bad'
            ELSE 'Good'
        END AS Label
    FROM netflix
) t
GROUP BY Label;

-- 16. Find the month with the highest number of content additions.

SELECT monthname(date_added) AS month_num, COUNT(date_added) AS Total_content FROM netflix
GROUP BY monthname(date_added)
ORDER BY Total_content DESC
LIMIT 1;


-- 17. Find the top 3 directors with the most content on Netflix.

WITH RECURSIVE split_director AS (

SELECT
	Show_id,
    TRIM(SUBSTRING_INDEX(director, ',', 1)) AS director,
	SUBSTRING(director, LENGTH(SUBSTRING_INDEX(director, ',', 1)) + 2) AS rest
    FROM netflix
    WHERE director IS NOT NULL AND director <> ''
    
    UNION ALL

    SELECT
        show_id,
        TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS director,
        SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2) AS rest
    FROM split_director
    WHERE rest IS NOT NULL AND rest <> ''
    )
    SELECT director, COUNT(*) AS total_content FROM split_director
    GROUP BY director
    ORDER BY total_content DESC
    LIMIT 3;

-- 18. Find the average duration of Movies.

SELECT ROUND(AVG(duration),2)  Avg_duration_min FROM netflix
WHERE type = 'Movie';


-- 19. Which country produces the most TV Shows?

WITH RECURSIVE split_country AS (
  
  SELECT 
      type,
      TRIM(SUBSTRING_INDEX(country, ',', 1)) AS country,
      SUBSTRING(country, LENGTH(SUBSTRING_INDEX(country, ',', 1)) + 2) AS rest
  FROM netflix
  WHERE country IS NOT NULL AND country <> ''

  UNION ALL

  SELECT 
      type,
      TRIM(SUBSTRING_INDEX(rest, ',', 1)) AS country,
      SUBSTRING(rest, LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2)
  FROM split_country
  WHERE rest <> ''
)
-- Now we will list the top country produces the most TV Shows
SELECT country, COUNT(*) AS total_TV_Shows
FROM split_country
WHERE country <> '' AND type = 'TV Show'
GROUP BY country
ORDER BY total_TV_Shows DESC
LIMIT 1;


-- 20. List all content titles that contain the word "Love" in the title.

SELECT title FROM netflix
WHERE title LIKE '%Love%';