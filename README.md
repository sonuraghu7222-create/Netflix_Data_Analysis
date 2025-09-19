# Netflix Movies and TV Shows Data Analysis using SQL  

![](https://github.com/yourusername/netflix_sql_project/blob/main/logo.png) 

## 📌 Overview  
This project analyzes the **Netflix Movies & TV Shows dataset** using **SQL**. The dataset contains information such as titles, directors, cast, countries, release years, ratings, durations, and descriptions.  

The goal is to **practice SQL skills** and extract insights into Netflix’s global content library. Through 20+ real-world business problems, the project demonstrates how SQL can be applied for data cleaning, exploration, and trend analysis.  

---

## 🎯 Objectives  
- Import, clean, and transform Netflix data for SQL analysis.  
- Compare **Movies vs. TV Shows** and explore content ratings.  
- Identify **top countries, directors, actors**, and genres.  
- Analyze **trends in content release** (yearly, monthly, last 5 years).  
- Work with **string operations, date functions, and recursive CTEs**.  
- Categorize content by keywords and create meaningful insights.  

---

## 📊 Dataset  
Dataset used: [Netflix Movies and TV Shows](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)  

---

## 🛠 Schema  
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(10),
    type         VARCHAR(20),
    title        VARCHAR(250),
    director     VARCHAR(550),
    cast         VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(20),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```  

---

## 💡 Business Problems Solved  

1. Count the number of Movies vs TV Shows  
2. Find the most common rating for Movies and TV Shows  
3. List all Movies released in a specific year (e.g., 2020)  
4. Find the top 5 countries with the most content on Netflix  
5. Identify the longest Movie  
6. Find content added in the last 5 years  
7. Find all Movies/TV Shows by director *Rajiv Chilaka*  
8. List all TV Shows with more than 5 seasons  
9. Count the number of content items in each genre  
10. Find each year and the average numbers of content released in India (Top 5 years)  
11. List all Movies that are Documentaries  
12. Find all content without a director  
13. Find how many Movies actor *Salman Khan* appeared in the last 10 years  
14. Find the top 10 actors with the highest appearances in Indian Movies  
15. Categorize content as **Good/Bad** based on keywords (*kill*, *violence*)  
16. Find the month with the highest content additions  
17. Find the top 3 directors with the most content on Netflix  
18. Find the average duration of Movies  
19. Which country produces the most TV Shows  
20. List all content titles containing the word *Love*  

---

## 📈 Findings & Insights  

- **Movies dominate** Netflix’s catalog, but TV Shows have grown significantly in recent years.  
- **TV-MA, TV-14, and TV-PG** are the most common ratings, showing Netflix’s focus on diverse audiences.  
- **United States, India, and United Kingdom** lead in content production.  
- India has shown **consistent growth** in Netflix content releases, with strong averages in the last 5 years.  
- **Rajiv Chilaka** and actors like **Salman Khan** appear multiple times, reflecting local industry presence.  
- Documentaries, multi-season shows, and trending genres highlight Netflix’s content variety.  
- Keyword categorization shows a mix of both **light and dark themes** in Netflix content.  

---

## ✅ Conclusion  
This project demonstrates how **SQL can be leveraged to clean, transform, and analyze real-world datasets**. By solving 20+ queries, the analysis provides insights into Netflix’s strategy across countries, genres, directors, and time periods.  

It showcases strong SQL skills including **joins, aggregations, date/time functions, string operations, CTEs, and recursive queries** — essential for any aspiring Data Analyst.  

---

## 👨‍💻 Author – Sonu Raghuwanshi  
This project is part of my portfolio to showcase SQL for data analytics.  

📌 Connect with me:  
- **LinkedIn**: https://www.linkedin.com/in/sonu-raghuwanshi--/  
- **GitHub**: https://github.com/sonuraghu7222-create 
