# Executive Summary: COVID-19 Exploratory Data Analysis

## Introduction
This exploratory data analysis (EDA) project in SQL investigates the impact of COVID-19 globally, focusing on infection rates, death percentages, and vaccination progress. The analysis explores key metrics like total cases, deaths, and infection rates relative to population, identifying countries with the highest infection and death rates. By leveraging SQL techniques such as CTEs, temporary tables, and window functions, the project calculates rolling vaccination totals and vaccination percentages by location. The data is further refined by filtering, grouping, and casting to handle data quality issues and create insights. Finally, a view is created for reusable insights on vaccination progress

## Key Findings
1. **Global and Country-Level Trends:**
- The analysis examines total cases, deaths, and infection rates across different countries.
- The highest infection rates were observed in smaller nations like Andorra, with over 17% of its population infected.
- The United States was analyzed separately to assess case percentage relative to population.

2. **Death Rate Analysis:**
- The study evaluates case fatality rates across different regions, with a focus on high-death-count countries.
- Data type inconsistencies in death counts were resolved using CAST() to ensure accurate aggregation.

3. **Continental-Level Trends:**
- The analysis also aggregates total deaths by continent, identifying the regions most affected.
- A global death percentage over time was calculated to observe trends in mortality.

4. **Vaccination Progress:**
- The project integrates vaccination data to track progress by country and continent.
- Using window functions (SUM OVER PARTITION BY), a rolling total of vaccinations was computed to visualize how vaccination efforts evolved over time.
- The percentage of the population vaccinated was calculated for specific locations, like Albania, to highlight disparities in vaccine distribution.

5. **Data Structuring for Insights:**
- The analysis leverages CTEs (Common Table Expressions) and temporary tables to organize data and simplify complex calculations.
- A view was created (Percentage_Vaccinated_People) to store vaccination insights for easy querying in future analyses.

## Conclusion
This EDA provides critical insights into the spread, severity, and response to COVID-19. The findings can help public health officials and policymakers understand which countries and regions were most affected and how vaccination efforts progressed. Future work could expand on this by integrating economic and social impact factors to assess the broader implications of the pandemic.
