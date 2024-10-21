/*Show how many titles from each year*/


SELECT DISTINCT releaseyear, count(title)
FROM imdb_data
GROUP BY releaseyear
ORDER BY releaseyear DESC


/*Show every titles within the Crime genre*/


SELECT *
FROM imdb_data
WHERE genres LIKE '%Crime%'


/*Average rating per year of movies with amount*/


SELECT releaseyear, ROUND(avg(averagerating),2) as average_rating, count(title) as number_of_movies
FROM imdb_data
GROUP BY releaseyear
ORDER BY releaseyear DESC


/*Show highest rated movie per year*/


WITH RankedMovies AS (
    SELECT
        title,
        releaseyear,
        averagerating,
        ROW_NUMBER() OVER (PARTITION BY releaseyear ORDER BY averagerating DESC) AS rank
    FROM imdb_data
    WHERE type = 'movie'
)
SELECT
    releaseyear,
    title,
    averagerating
FROM RankedMovies
WHERE rank = 1
ORDER BY releaseyear DESC;


/* Count of each category with more than 9 in average rating and 10,000 votes*/

SELECT type, COUNT(title) AS count
FROM imdb_data
WHERE averageRating > 9 AND numvotes > 10000
GROUP BY type;


/* Separating the genres column into 3 */


 select title,
        split_part(genres, ',', 1) as genre1, 
        split_part(genres, ',', 2) as genre2,
        split_part(genres, ',', 3) as genre3,
        averagerating,
        numvotes,
        releaseyear
 from imdb_data


/* Count each category from the genres column */

WITH genre_split AS (
    SELECT TRIM(BOTH ' ' FROM LOWER(unnest(string_to_array(genres, ',')))) as genre
    FROM imdb_data
)
SELECT genre, COUNT(*) as genre_count
FROM genre_split
GROUP BY genre
ORDER BY genre_count DESC;
