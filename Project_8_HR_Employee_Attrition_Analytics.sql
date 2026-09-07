-- ============================================================
-- PROJECT 8: HR EMPLOYEE ATTRITION ANALYTICS
-- Database: MySQL 8+
-- Dataset: WA_Fn-UseC_-HR-Employee-Attrition.csv
-- ============================================================

CREATE DATABASE IF NOT EXISTS hr_analytics;
USE hr_analytics;

-- 1. Main table
DROP TABLE IF EXISTS hr_employee_attrition;

CREATE TABLE hr_employee_attrition (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(100),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(100),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(20),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(100),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(30),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(5),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

-- 2. Import CSV
-- Change the file path below to the actual location on your computer.
-- Example for MySQL Server:
-- LOAD DATA LOCAL INFILE 'C:/path/WA_Fn-UseC_-HR-Employee-Attrition.csv'
-- INTO TABLE hr_employee_attrition
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;

-- If LOCAL INFILE is disabled, import the CSV through MySQL Workbench:
-- Table Data Import Wizard -> select CSV -> map columns -> import.

-- ============================================================
-- BASIC DATA QUALITY
-- ============================================================

-- 3. Total employees
SELECT COUNT(*) AS total_employees
FROM hr_employee_attrition;

-- 4. Duplicate EmployeeNumber check
SELECT EmployeeNumber, COUNT(*) AS duplicate_count
FROM hr_employee_attrition
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- 5. Attrition distribution
SELECT
    Attrition,
    COUNT(*) AS employees,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM hr_employee_attrition), 2) AS percentage
FROM hr_employee_attrition
GROUP BY Attrition;

-- ============================================================
-- EXECUTIVE HR KPIs
-- ============================================================

-- 6. Main HR KPI dashboard
SELECT
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS attrition_rate_pct,
    ROUND(AVG(Age), 2) AS average_age,
    ROUND(AVG(MonthlyIncome), 2) AS average_monthly_income,
    ROUND(AVG(YearsAtCompany), 2) AS average_years_at_company,
    ROUND(SUM(CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overtime_rate_pct
FROM hr_employee_attrition;

-- ============================================================
-- ATTRITION ANALYSIS
-- ============================================================

-- 7. Attrition by department
SELECT
    Department,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    ROUND(AVG(YearsAtCompany), 2) AS avg_tenure
FROM hr_employee_attrition
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- 8. Attrition by job role
SELECT
    JobRole,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income
FROM hr_employee_attrition
GROUP BY JobRole
ORDER BY attrition_rate_pct DESC;

-- 9. Attrition by overtime
SELECT
    OverTime,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY OverTime
ORDER BY attrition_rate_pct DESC;

-- 10. Attrition by business travel
SELECT
    BusinessTravel,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY BusinessTravel
ORDER BY attrition_rate_pct DESC;

-- 11. Attrition by marital status
SELECT
    MaritalStatus,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY MaritalStatus
ORDER BY attrition_rate_pct DESC;

-- 12. Attrition by gender
SELECT
    Gender,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY Gender
ORDER BY attrition_rate_pct DESC;

-- ============================================================
-- AGE / TENURE / INCOME
-- ============================================================

-- 13. Attrition by age band
SELECT
    CASE
        WHEN Age <= 25 THEN '<=25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY age_group
ORDER BY
    CASE age_group
        WHEN '<=25' THEN 1
        WHEN '26-35' THEN 2
        WHEN '36-45' THEN 3
        WHEN '46-55' THEN 4
        ELSE 5
    END;

-- 14. Attrition by tenure band
SELECT
    CASE
        WHEN YearsAtCompany <= 1 THEN '0-1'
        WHEN YearsAtCompany BETWEEN 2 AND 3 THEN '2-3'
        WHEN YearsAtCompany BETWEEN 4 AND 5 THEN '4-5'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN '6-10'
        ELSE '11+'
    END AS tenure_band,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(MonthlyIncome), 2) AS avg_income
FROM hr_employee_attrition
GROUP BY tenure_band
ORDER BY attrition_rate_pct DESC;

-- 15. Average employee metrics by attrition
SELECT
    Attrition,
    ROUND(AVG(Age), 2) AS avg_age,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    ROUND(AVG(TotalWorkingYears), 2) AS avg_total_working_years,
    ROUND(AVG(YearsAtCompany), 2) AS avg_years_at_company,
    ROUND(AVG(YearsInCurrentRole), 2) AS avg_years_current_role,
    ROUND(AVG(YearsWithCurrManager), 2) AS avg_years_with_manager,
    ROUND(AVG(YearsSinceLastPromotion), 2) AS avg_years_since_promotion
FROM hr_employee_attrition
GROUP BY Attrition;

-- ============================================================
-- SATISFACTION / ENGAGEMENT
-- ============================================================

-- 16. Job satisfaction
SELECT
    JobSatisfaction,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- 17. Environment satisfaction
SELECT
    EnvironmentSatisfaction,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- 18. Work-life balance
SELECT
    WorkLifeBalance,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- 19. Job involvement
SELECT
    JobInvolvement,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY JobInvolvement
ORDER BY JobInvolvement;

-- ============================================================
-- HIGH-RISK RETENTION SEGMENTS
-- ============================================================

-- 20. Overtime + job level + marital status risk segments
SELECT
    OverTime,
    JobLevel,
    MaritalStatus,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY OverTime, JobLevel, MaritalStatus
HAVING COUNT(*) >= 10
ORDER BY attrition_rate_pct DESC, employees DESC;

-- 21. High-risk job roles with minimum 20 employees
SELECT
    JobRole,
    COUNT(*) AS employees,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct
FROM hr_employee_attrition
GROUP BY JobRole
HAVING COUNT(*) >= 20
ORDER BY attrition_rate_pct DESC;

-- ============================================================
-- FINAL MANAGEMENT VIEW
-- ============================================================

-- 22. Department management summary
SELECT
    Department,
    COUNT(*) AS employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_pct,
    ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction,
    ROUND(AVG(EnvironmentSatisfaction), 2) AS avg_environment_satisfaction,
    ROUND(AVG(WorkLifeBalance), 2) AS avg_work_life_balance,
    ROUND(AVG(MonthlyIncome), 2) AS avg_monthly_income,
    ROUND(AVG(YearsAtCompany), 2) AS avg_tenure
FROM hr_employee_attrition
GROUP BY Department
ORDER BY attrition_rate_pct DESC;

-- ============================================================
-- END OF PROJECT 8 SQL
-- ============================================================
