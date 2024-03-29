# youtube-data-analysis

1)Background story:
YouTube is the world's largest video streaming platform, where billions of videos are consumed daily across the world. YouTube is planning to increase video views by optimizing trending duration across the globe. The Head of Product – trending videos, after his meeting with senior level executives, had a task for his team. YouTube wanted to understand the impact of Likes, comments, dislikes on the video consumption for the videos that were trending. The head of product has assigned the task to your manager, and the manager has assigned the task to you with the brief and business problem.

2)Business Problem:
YouTube’s trending videos vary by location across the world. The impact of likes, dislikes, comments may differ based on the countries. The demographics of countries itself is a big factor in the way videos are consumed in various countries. The videos can be trending if video views are above a certain level. Your manager wants to present an analysis on how average trending periods of videos vary across countries. How the likes, dislikes, comments impact the duration of trending videos. Your manager has also asked for some interesting insights from the data which could be done through exploratory data analysis.

3)Dataset concept:
There are 3 tables available for the analysis
YT_trending_videos: This table has video level information along with dates on which videos were trending along with metrics such as comments, likes, views, etc. 
YT_channel_map: This table has channel_id mapping with the channel title which is also interpreted as channel name
YT_category_map: This table has category_id mapping. The videos on YouTube are mapped to a category based on the type of video such as Movie, trailer, animation, etc.

Questions

Question1: How many videos have trended for more than 5 days in the US?

Question2: Which category has the highest average trending period?

Question3: How many distinct videos trended from the category ‘Music’ on weekdays (Monday - Friday)?

Question4: What are the total views for category sports in ‘Canada’?

Question5:Rank the videos based on views, likes within each country. Which country has the highest number of videos with rank for views and rank of likes both in top 20?

Question6: What is the average rating of the category Music?

Question7: Which category has the highest average rating based on likes?
