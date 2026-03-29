# 📊 COVID-19 Time Series Analysis

![R](https://img.shields.io/badge/R-Statistical%20Analysis-blue?logo=r)
![Status](https://img.shields.io/badge/Status-Completed-success)
![License](https://img.shields.io/badge/License-Academic-lightgrey)

---

## 📌 Project Overview

This project analyzes **global COVID-19 time series data** using R. It focuses on understanding patterns in confirmed cases, deaths, and recoveries through data transformation, visualization, and statistical analysis.

---

## 🧠 Key Objectives
✅ Analyze global pandemic trends  
✅ Visualize time series patterns  
✅ Compute daily changes and growth rates  
✅ Identify high-impact countries  
✅ Extract meaningful insights from real-world data  

---

## 📂 Dataset

**Source:** Johns Hopkins University (via data.world)

**Features:**

* 📅 Date
* 🌍 Country/Region
* 📈 Confirmed Cases
* ☠️ Deaths
* 💚 Recovered

---

## ⚙️ Methodology

### 🔹 Data Processing

* Converted wide → long format (`pivot_longer`)
* Merged multiple datasets
* Cleaned missing and inconsistent values

### 🔹 Analysis

* Aggregated global and country-level data
* Calculated:

  * Daily new cases
  * Growth rates (%)

### 🔹 Visualization

* 📈 Time series plots
* 📊 Bar charts (Top countries)
* 📉 Growth rate trends
* 🔄 Daily case fluctuations

---

## 📊 Key Insights

* 📌 COVID-19 exhibited **exponential growth** during early stages
* 📌 Major peaks occurred around **2021–2022**
* 📌 Growth rates **declined over time**, indicating stabilization
* 📌 **USA and India** recorded the highest total cases
* 📌 Death trends show a **lag effect** relative to confirmed cases

---

## 🗂️ Project Structure

```
covid19-time-series-analysis/
│
├── data/        # Raw datasets
├── scripts/     # R scripts
├── README.md
└── .gitignore
```

---

## ▶️ How to Run

1. Open **RStudio**
2. Load your script:

   ```
   scripts/covid_analysis.R
   ```
3. Ensure dataset is inside `/data`
4. Run the script

---

## 📦 Requirements

Install required packages:

```r
install.packages(c("tidyverse", "lubridate"))
```

---



## 👨‍💻 Author

**Wency N. Jorda**

---

## 📌 Notes

* Recovery data may be incomplete due to reporting differences
* Early spikes in growth rate are due to low initial values

---

## ⭐ Project Value

This project demonstrates:

* Time series analysis
* Data wrangling in R
* Visualization skills
* Real-world dataset handling

---

## 📜 License

This project is for academic purposes only.
