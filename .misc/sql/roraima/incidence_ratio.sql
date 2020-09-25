SELECT
  ratio AS "Taxa de Incidência",
  disease AS "Doença ou Agravo",
  icd_10 AS "Código da Doença ou Agravo",
  year AS "Ano",
  geo_id AS "Estado ou Município"
FROM (
  SELECT
    (CAST(incidence AS FLOAT) / CAST(population AS FLOAT)) * 100000.0 AS ratio,
    incidence,
    population,
    disease,
    icd_10,
    year,
    city_id AS geo_id
  FROM (
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'HIV/AIDS' AS disease,
        'B20-B24' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
        WHERE BD.block_id = 'B20-B24'
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'HIV/AIDS' AS disease,
        'B20-B24' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
        WHERE BD.block_id = 'B20-B24'
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
    UNION ALL
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'Tuberculose' AS disease,
        'A15-A19' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
        WHERE BD.block_id = 'A15-A19'
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'Tuberculose' AS disease,
        'A15-A19' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
        WHERE BD.block_id = 'A15-A19'
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
    UNION ALL
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'Dengue' AS disease,
        'A90-A91' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        WHERE MR.disease_id IN ('A90', 'A91')
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'Dengue' AS disease,
        'A90-A91' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        WHERE MR.disease_id IN ('A90', 'A91')
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
    UNION ALL
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'Leishmaniose tegumentar americana' AS disease,
        'B55.1-B55.2' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        WHERE sub_disease_id IN ('B55.1', 'B55.2')
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'Leishmaniose tegumentar americana' AS disease,
        'B55.1-B55.2' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        WHERE sub_disease_id IN ('B55.1', 'B55.2')
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
    UNION ALL
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'Leishmaniose visceral' AS disease,
        'B55.0' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        WHERE sub_disease_id = 'B55.0'
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'Leishmaniose visceral' AS disease,
        'B55.0' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        WHERE sub_disease_id = 'B55.0'
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
    UNION ALL
    (
      SELECT
        total AS population,
        CYP.year,
        CYP.city_id,
        incidence,
        'Hanseníase' AS disease,
        'A30' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          id_municip AS city_id
        FROM morbidity_registries AS MR
        WHERE disease_id = 'A30'
        GROUP BY year, city_id
      ) AS MR
      ON CYP.city_id = MR.city_id AND CYP.year = MR.year
    )
    UNION ALL
    (
      SELECT
        SUM(total) AS population,
        CYP.year,
        14 AS city_id,
        incidence,
        'Hanseníase' AS disease,
        'A30' AS icd_10
      FROM cities_year_population AS CYP
      LEFT JOIN (
        SELECT
          COUNT(*) AS incidence,
          year,
          14 AS city_id
        FROM morbidity_registries AS MR
        WHERE disease_id = 'A30'
        GROUP BY year
      ) AS MR ON CYP.year = MR.year
      GROUP BY CYP.year, incidence, disease, icd_10
    )
  ) AS source
) AS source
WHERE year = {{year}} AND geo_id = {{geo_id}} [[AND icd_10 = {{icd_10}}]]
