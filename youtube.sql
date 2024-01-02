-- Question1: How many videos have trended for more than 5 days in the US?
with trends as (select video_id , title , country  ,count(trending_date)as number_of_treandingdays from yt_trending_videos
         where country = 'US'
         group by 
                video_id,
                title ,
                country
            having count(trending_date) > 5
            order by number_of_treandingdays desc)
            select count(video_id) , country from trends
                group by country;
-- method2
SELECT country,
       COUNT(video_id) AS no_of_videos
FROM   (SELECT video_id, title, country, COUNT(trending_date) AS no_of_days_trended
        FROM   yt_trending_videos
        GROUP  BY video_id, title, country) a
WHERE  no_of_days_trended > 5
       AND country = 'US'
GROUP  BY country;
                
-- Question2: Which category has the highest average trending period?

SELECT snippettitle,
       Avg(treanding_days)
FROM   (SELECT b.snippettitle,
               Count(a.trending_date)AS treanding_days,
               a.title,
               a.video_id
        FROM   yt_trending_videos a
               JOIN yt_category_map b
                 ON a.category_id = b.id
        GROUP  BY b.snippettitle,
                  a.title,
                  a.video_id) A
GROUP  BY snippettitle
ORDER  BY Avg(treanding_days) DESC 

-- Question3: How many distinct videos trended from the category ‘Music’ on weekdays (Monday - Friday)?
SELECT Count(DISTINCT( video_id )),
       snippettitle
FROM   yt_trending_videos a
       JOIN yt_category_map b
         ON a.category_id = b.id
WHERE  snippettitle = 'Music'
       AND Dayname(a.trending_date) BETWEEN 0 AND 4
GROUP  BY snippettitle;

-- method2
SELECT Count(DISTINCT( video_id )),
       snippettitle
FROM   yt_trending_videos a
       JOIN yt_category_map b
         ON a.category_id = b.id
WHERE  snippettitle = 'Music'
       AND Dayname(trending_date) IN ( 'Monday', 'Tuesday', 'Wednesday',
                                       'Thursday',
                                       'Friday' )
GROUP  BY 2 

-- Question4: What are the total views for category sports in ‘Canada’?
SELECT Sum(total_views)   AS total_views,
       Sum(total_likes)   AS total_likes,
       Avg(trandingdates) AS average_trending_dates,
       country,
       snippettitle
FROM   (SELECT Sum(views)           AS total_views,
               Sum(likes)           AS total_likes,
               Count(trending_date) AS trandingdates,
               country,
               snippettitle
        FROM   yt_trending_videos a
               JOIN yt_category_map b
                 ON a.category_id = b.id
        WHERE  country = 'Canada'
               AND snippettitle = 'sports'
        GROUP  BY country,
                  snippettitle) a
GROUP  BY country,
          snippettitle;
          
-- Question5 : Rank the videos based on views, likes within each country. 
-- Which country has the highest number of videos with rank for views and rank of likes both in top 20?
SELECT COUNT(video_id) AS number_of_videos , country
FROM(SELECT 
    video_id,
    title,
    country,
    views,
    likes,
    ROW_NUMBER() OVER (PARTITION BY country ORDER BY views DESC) AS views_rank,
    RANK() OVER (PARTITION BY country ORDER BY likes DESC) AS likes_rank
FROM 
    yt_trending_videos)a
    where views_rank <= 20 
    and likes_rank <= 20 
    group by country 
    order by number_of_videos desc
    
-- methord2

with trending as (SELECT 
    video_id,
    title,
    country,
    views,
    likes,
    ROW_NUMBER() OVER (PARTITION BY country ORDER BY views DESC) AS views_rank,
    RANK() OVER (PARTITION BY country ORDER BY likes DESC) AS likes_rank
FROM 
    yt_trending_videos)
select * from trending

-- Question6: What is the average rating of the category Music?
-- case
-- We have determined that the Likes to dislikes ratio is a good indicator of popularity. We have to come up with a rating framework to
-- the videos based on the available metrics,which would help us recommend videos better.
-- Generate a report at video level with video viewership rating within the category. 
-- (Report at video level means the output should be unique at video_id).
-- Formula to assign the rating: ((Views - min(views))*100 ) / max(views) - min(views)
-- where max(views) is maximum views in the respective video’s category
-- and min(views) is minimum views in the respective video’s category
SELECT category_title,
       Avg(rating) AS avg_rating
FROM   (SELECT c.*,
               Round(( ( views - min_views ) * 100 ) / ( max_views - min_views )
               , 0) AS
                      rating
        FROM   (SELECT DISTINCT video_id,
                                title,
                                snippettitle                  AS category_title,
                                views,
                                Max(views)
                                  OVER (
                                    partition BY category_id) AS max_views,
                                Min(views)
                                  OVER (
                                    partition BY category_id) AS min_views
                FROM   yt_trending_videos a
                       INNER JOIN yt_category_map b
                               ON a.category_id = b.id) c) d
GROUP  BY category_title 