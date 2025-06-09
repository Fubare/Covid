# COVID-19 Mortality Analysis in England

This project explores the major socio-demographic and behavioral factors contributing to COVID-19-related deaths in England. 
It combines data from the Office for National Statistics and other sources with statistical modeling and data science tools to uncover regional risk patterns. 
The goal is to inform future public health planning by highlighting key drivers of mortality during the pandemic.

---

## Key Objectives

- Identify significant predictors of COVID-19 deaths across districts
- Evaluate the impact of age, ethnicity, education, transport mode, and religion
- Use exploratory data analysis, factor analysis, and regression modeling
- Highlight the role of behavioral and demographic structures in shaping outcomes

---

## Tools & Technologies

- **R / RStudio** – for statistical modeling and visualization
- **SQLite** – for merging and querying large datasets
- **Excel** – for initial data cleaning and formatting
- **Statistical Methods**: Factor analysis, Principal Component Analysis (PCA), Multiple Linear Regression, Normality Testing

---

## Data Sources

- **COVID-19 Deaths Data** – Provided via UEL Moodle (CSV format)
- **2021 Census Data** – Downloaded from the Office for National Statistics (NOMIS)
- All data standardized per thousand population and merged using district codes

---

## Key Findings

- **Taxi usage** is positively associated with higher COVID-19 mortality.
- **Bicycle commuting** and **remote work** are negatively associated with deaths.
- A higher **proportion of children** in a population correlates with increased mortality risk.
- Final regression model (Adj. R² ≈ 14.1%) identifies key actionable variables for policy response.

---

## Methodology Overview

1. **Data Merging and Cleaning**: Districts standardized and merged from different sources.
2. **EDA**: Visual analysis with histograms, boxplots, Q-Q plots.
3. **Normality Checks**: Shapiro-Wilk and Kolmogorov-Smirnov tests.
4. **Correlation Testing**: Spearman correlation analysis.
5. **Dimensionality Reduction**: Factor analysis and PCA.
6. **Modeling**: Multiple Linear Regression on selected components.

---

## Notable Scripts and Files

- `Covid_19.docx` – Full report with figures, tests, and methodology
- `covid_cleaned.csv` – Merged and processed dataset (optional)
- `covid_analysis.R` – R script for preprocessing, EDA, and modeling
- `queries.sql` – SQL queries used for data joining and updating district codes

---

## Conclusion

This analysis highlights that everyday behavioral factors,such as transport mode and working patterns,significantly influence COVID-19 mortality. 
Policies promoting active transport and remote work could help reduce vulnerability during pandemics.
Demographics like child population also indicate the need for nuanced strategies in public health planning.

---

## Author

- **Daniel Ogaji-Amachree**  

---

## References

Key sources include academic papers, census data, and official COVID-19 statistics. Full reference list available in the project report.

---

