# Olist E-Commerce Order Funnel & Delivery Performance Analysis

## Overview
End-to-end product analytics project analysing 99,441 orders from 
Olist Brazil (2016–2018) using Python, Pandas, MySQL and Tableau.

## Key Findings
- 97% delivery rate but 6.8% of orders arrive late
- Late deliveries cause a 2.44-star drop in review scores (4.29 → 1.85)
- SP and RJ drive 54% of total orders — highest priority delivery fix
- 96.9% of customers ordered only once — major retention opportunity

## Tools Used
|     Tool        | Purpose                              |
|-----------------|--------------------------------------|
| Python + Pandas | Data cleaning and pipeline           |
| MySQL           | Data storage and SQL analysis        |
| Tableau Public  | Interactive dashboard and data story |

## Project Structure
```
olist-ecommerce-analysis/
├── notebooks/
│   ├── 01_orders_cleaning.ipynb
│   ├── 02_customers_cleaning.ipynb
│   ├── 03_items_cleaning.ipynb
│   ├── 04_reviews_cleaning.ipynb
│   └── 05_merge_and_export.ipynb
├── sql/
│   └── olist_sql_analysis.sql
├── data/
│   ├── cleaned_orders.csv
│   ├── cleaned_customers.csv
│   ├── cleaned_items.csv
│   └── cleaned_reviews.csv
└── README.md
```

## Live Dashboard
[View on Tableau Public](https://public.tableau.com/app/profile/vasupradha.v3779/vizzes)

## story 
[download to view the story](https://drive.google.com/file/d/1F4k9EJ9vgF5ojwVYUMLWpBaxLS8CkuRa/view?usp=sharing)

## Dataset
[Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)