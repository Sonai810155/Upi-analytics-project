CREATE DATABASE IF NOT EXISTS upi_warehouse;
USE upi_warehouse;

CREATE TABLE IF NOT EXISTS dim_date (
    month_start DATE PRIMARY KEY,
    year INT,
    month INT,
    quarter INT,
    days_in_month INT,
    festival_name VARCHAR(60),
    is_festival_month TINYINT
);

CREATE TABLE IF NOT EXISTS fact_upi_monthly (
    month_start DATE PRIMARY KEY,
    banks_live INT,
    volume_mn DECIMAL(12,2),
    value_cr DECIMAL(16,2),
    FOREIGN KEY (month_start) REFERENCES dim_date(month_start)
);