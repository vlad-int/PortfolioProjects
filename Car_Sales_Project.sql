-- A table showing total EV sales for each year (a line chart of EV adoption trends)
SELECT Year, SUM(EV_value) AS total_ev_sales
    From project113.car_sales
    GROUP BY Year 
    ORDER BY Year;


-- A table ranking regions by total EV sales (map visualization)
SELECT Region, SUM(EV_value) AS total_ev_sales
    FROM project113.car_sales
    GROUP BY region
    ORDER BY total_ev_sales DESC;


-- A table showing EV and Non-EV sales along with the EV percentage(a bar chart comparing regions or years)
SELECT Region, SUM(EV_value) AS total_ev_sales, CAST(SUM(Non_EV_value) as UNSIGNED) AS total_non_ev_sales, 
REPLACE(ROUND((SUM(EV_value)*100) / (SUM(EV_value) + SUM(Non_EV_value)), 2), ".", "," )AS ev_percentage
    From project113.car_sales
    GROUP BY Region
    ORDER BY ev_percentage DESC;


-- A table showing EV sales and their year-over-year growth rate (a line chart showing sales growth)
WITH sales_data AS (
    SELECT 
        Year, 
        SUM(EV_value) AS total_ev_sales,
        LAG(SUM(EV_value)) OVER (ORDER BY Year) AS previous_year_sales,
        ROUND(((SUM(EV_value) - LAG(SUM(EV_value)) OVER (ORDER BY Year)) * 100) / LAG(SUM(EV_value)) OVER (ORDER BY Year), 2) AS growth_rate
    FROM project113.car_sales
    GROUP BY Year
)
SELECT Year, total_ev_sales, previous_year_sales, 
       REPLACE(growth_rate, ".", ",") AS growth_rate
FROM sales_data
WHERE previous_year_sales IS NOT NULL
ORDER BY Year;



-- A table showing each region's percentage contribution to overall EV sales (a pie chart)
SELECT Region, SUM(EV_value) AS total_ev_sales,
REPLACE(Round((SUM(EV_value) * 100) / (SELECT SUM(EV_value) FROM project113.car_sales WHERE Region NOT IN ('World', "Europe", "European Union (27)")), 2), ".", "," ) as region_percentage
    FROM project113.car_sales
    WHERE Region NOT IN ('World', "Europe", "European Union (27)")
    GROUP BY region
    ORDER BY total_ev_sales DESC;
    


-- A table comparing EV and Non-EV sales across regions (a stacked bar chart)
SELECT Region, SUM(EV_value) AS total_ev_sales,  CAST(SUM(Non_EV_value) as UNSIGNED) AS total_non_ev_sales
    FROM project113.car_sales
    GROUP BY region
    ORDER BY total_ev_sales DESC;
