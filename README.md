# Data Warehouse Project

This project demonstrates a data warehousing solution, from building a data warehouse to generating business ready data model.

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:

1. **Bronze Layer**: Stores raw data directly as it is into postgreSQL in a Docker Container.
2. **Silver Layer**: Perform data cleaning, standarization, and normalization to prepare for analysis.
3. **Gold Layer**: Business-ready data modeled into a star schema required for reporting and analytics.

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a Modern Data Warehouse Using Medallion Architecture **Bronze**, **Silver**, and **Gold** layers.
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into the warehouse.
3. **Data Modeling**: Developing fact and dimension tables optimized for analytical queries.

---

## 🚀 Project Set Up

**Build the docker container for postgres and pgadmin**

```
docker-compose up
```

The container will set up a postges and pgadmin under the same network and initialize DB, schema, as well as running all the SQL script for all layers.

---




 
