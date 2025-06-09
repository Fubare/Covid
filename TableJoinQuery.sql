WITH CovidDeathUpdatedCode AS (
    SELECT
        COALESCE(file.NEW_CODE, COVID_19_deaths.LA_code) AS DistrictCode,
        SUM(COVID_19_deaths.Total_deaths) AS TotalDeaths
    FROM COVID_19_deaths
    LEFT JOIN file
        ON file.ORIG_CODE = COVID_19_deaths.LA_code
    GROUP BY COALESCE(file.NEW_CODE, COVID_19_deaths.LA_code)
)

SELECT 
    CovidDeathUpdatedCode.DistrictCode, 
    Ne_code.LAD23NM, 
    CovidDeathUpdatedCode.TotalDeaths
FROM Ne_code
JOIN CovidDeathUpdatedCode
    ON Ne_code.LAD23CD = CovidDeathUpdatedCode.DistrictCode
WHERE Ne_code.LAD23CD LIKE 'E%';




WITH CovidDeathUpdatedCode AS (
    SELECT
        COALESCE(file.NEW_CODE, COVID_19_deaths.LA_code) AS DistrictCode,
        SUM(COVID_19_deaths.Total_deaths) AS TotalDeaths
    FROM COVID_19_deaths
    LEFT JOIN file
        ON file.ORIG_CODE = COVID_19_deaths.LA_code
    GROUP BY COALESCE(file.NEW_CODE, COVID_19_deaths.LA_code)
)

SELECT CovidDeathUpdatedCode.DistrictCode, Ne_code.LAD23NM, CovidDeathUpdatedCode.Totaldeaths
FROM Ne_code
JOIN CovidDeathUpdatedCode, ON Ne_code.LAD23CD = CovidDeathUpdatedCode.DistrictCode
WHERE Ne_code.LAD23CD LIKE "E%"

SELECT
    f.LA_code, -- LA_code from Covid-death table
    f.LA_name, -- LA_name from Covid-death table
    -- Columns from Ethnic table corresponding to Covid-death
    a.* EXCEPT(LA_code, LA_name),
    -- Columns from Religion table corresponding to Covid-death
    b.* EXCEPT(LA_code, LA_name),
    -- Columns from Qualification table corresponding to Covid-death
    c.* EXCEPT(LA_code, LA_name),
    -- Columns from Travel-method table corresponding to Covid-death
    d.* EXCEPT(LA_code, LA_name),
    -- Columns from Travel-method table corresponding to Covid-death
    e.* EXCEPT (LA_Code, LA_Name)
FROM
    `abm-tek.covid.covid-death` AS f
LEFT JOIN
    `abm-tek.covid.ethnic` AS a
ON
    f.LA_code = a.LA_code
LEFT JOIN
    `abm-tek.covid.religion` AS b
ON
    f.LA_code = b.LA_code
LEFT JOIN
    `abm-tek.covid.qualification` AS c
ON
    f.LA_code = c.LA_code
LEFT JOIN
    `abm-tek.covid.travel-method` AS d
ON
    f.LA_code = d.LA_code
LEFT JOIN
    `abm-tek.covid.age` AS e
ON
    f.LA_Code = e.LA_Code;
