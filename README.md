<<<<<<< HEAD
# Olist E-Commerce Order Funnel & Delivery Performance Analysis

## Overview
End-to-end product analytics project analysing 99,441 orders from the 
Brazilian e-commerce platform Olist (2016–2018) using Python, Pandas, MySQL and Tableau Public.

## Key Findings
- 97% delivery rate but 6.8% of orders arrive late
- Late deliveries cause a 2.44-star drop in review scores (4.29 → 1.85)
- SP and RJ drive 54% of total orders — highest priority delivery fix
- 96.9% of customers ordered only once — major retention opportunity

## Product Recommendation
Prioritize delivery reliability in SP and RJ over new feature development. 
A 10% improvement in on-time delivery in these 2 states would protect 
54% of total order volume from churn risk.


## Tools Used
|     Tool        | Purpose                              |
|-----------------|--------------------------------------|
| Python          | Data extraction and pipeline         |
| Pandas          | Data cleaning and transformation     |
| MySQL           | Data storage and SQL analysis        |
| Tableau Public  | Interactive dashboard and data story |

## Project Structure
```
olist-ecommerce-analysis/
│
├── data/
│   ├── raw/                        ← original Olist dataset files
│   └── processed/
│       ├── cleaned_customers.csv
│       ├── cleaned_items.csv
│       ├── cleaned_orders.csv
│       └── cleaned_reviews.csv
│
├── notebooks/
│   ├── orders_clean.ipynb          ← orders data cleaning
│   ├── customers_clean.ipynb       ← customers data cleaning
│   ├── items_clean.ipynb           ← items data cleaning
│   ├── reviews_clean.ipynb         ← reviews data cleaning
│   └── merge and export.ipynb      ← merge all + export to MySQL
│
├── sql/
│   └── analysis of ecommerce_olist_db.sql   ← all 14 analysis queries
│
├── reports/
│   └── story.pdf                   ← 8-slide data story
│
├── dashboard/
│   └── Dashboard results/          ← CSV exports for Tableau
│
└── README.md
```

## Live Dashboard
[View on Tableau Public](https://public.tableau.com/app/profile/vasupradha.v3779/vizzes)

## story 
[download to view the story](https://drive.google.com/file/d/1F4k9EJ9vgF5ojwVYUMLWpBaxLS8CkuRa/view?usp=sharing)

## Dataset
[Brazilian E-Commerce Public Dataset by Olist — Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

