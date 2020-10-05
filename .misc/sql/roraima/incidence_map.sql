SELECT
  incidence AS "Incidência",
  disease AS "Doença ou Agravo",
  icd_10 AS "Código da Doença ou Agravo",
  year AS "Ano",
  geo_id AS "Estado ou Município"
FROM (
  SELECT
    incidence,
    disease,
    icd_10,
    year,
    city_id AS geo_id
  FROM (
    (
      SELECT
        COUNT(*) AS incidence,
        'Sarampo' AS disease,
        'B05' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'B05'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Difteria' AS disease,
        'A36' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'B05'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Coqueluche' AS disease,
        'A37' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE MR.disease_id = 'A37'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Tétano neonatal' AS disease,
        'A33' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A33'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Tétano, exceto o tétano neonatal' AS disease,
        'A34' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A34'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Febre amarela, silvestre e urbana' AS disease,
        'A95' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A95'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Mordedura provocada por cão' AS disease,
        'W54' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'W54'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Hepatite B' AS disease,
        'B16' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'B16'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Hepatite aguda C' AS disease,
        'B17.1' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE sub_disease_id = 'B17.1'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Cólera' AS disease,
        'A00' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A00'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Febre hemorrágica da dengue' AS disease,
        'A91' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A91'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Sífilis congênita em menores de 1 ano de idade' AS disease,
        'A50' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A50'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Rubéola' AS disease,
        'B06' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'B06'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Rubéola congênita' AS disease,
        'P35.0' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE sub_disease_id = 'P35.0'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Doença meningocócica' AS disease,
        'A39' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A39'
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Meningite (bacteriana, viral, inclui a meningocócica)' AS disease,
        'A17.0,A39.0,A87,G00-G03' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id IN ('A87', 'G00', 'G01', 'G02', 'G03') OR sub_disease_id IN ('A17.0', 'A39.0')
      GROUP BY year, city_id
    )
    UNION ALL
    (
      SELECT
        COUNT(*) AS incidence,
        'Leptospirosis' AS disease,
        'A27' AS icd_10,
        year,
        id_municip AS city_id
      FROM morbidity_registries AS MR
      WHERE disease_id = 'A27'
      GROUP BY year, city_id
    )
  ) AS source
) AS source
WHERE year = {{year}} AND icd_10 = {{icd_10}}
