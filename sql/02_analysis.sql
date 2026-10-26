USE upi_warehouse;

-- Query 1: growth and daily average
WITH base AS (
    SELECT f.month_start, f.volume_mn, f.value_cr,
           d.days_in_month, d.is_festival_month,
           f.volume_mn / d.days_in_month AS daily_avg_mn
    FROM fact_upi_monthly f
    JOIN dim_date d ON f.month_start = d.month_start
)
SELECT month_start,
       volume_mn,
       ROUND(daily_avg_mn, 1) AS daily_avg_mn,
       ROUND((volume_mn / LAG(volume_mn) OVER (ORDER BY month_start) - 1) * 100, 2) AS mom_pct,
       ROUND((volume_mn / LAG(volume_mn, 12) OVER (ORDER BY month_start) - 1) * 100, 2) AS yoy_pct,
       ROUND((daily_avg_mn / LAG(daily_avg_mn) OVER (ORDER BY month_start) - 1) * 100, 2) AS daily_mom_pct
FROM base
ORDER BY month_start;


-- Query 2: festival vs. other months (daily-adjusted growth)
WITH base AS (
    SELECT f.month_start, d.is_festival_month,
           f.volume_mn / d.days_in_month AS daily_avg_mn
    FROM fact_upi_monthly f
    JOIN dim_date d ON f.month_start = d.month_start
),
growth AS (
    SELECT month_start, is_festival_month,
           (daily_avg_mn / LAG(daily_avg_mn) OVER (ORDER BY month_start) - 1) * 100 AS daily_mom_pct
    FROM base
)
SELECT is_festival_month,
       COUNT(*) AS months,
       ROUND(AVG(daily_mom_pct), 2) AS avg_daily_mom_pct
FROM growth
WHERE daily_mom_pct IS NOT NULL
GROUP BY is_festival_month;