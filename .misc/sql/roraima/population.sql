SELECT
  total AS "População residente",
  year AS "Ano",
  geo_id AS "Estado ou Município"
FROM (
  (
    SELECT
      total,
      year,
      city_id AS geo_id
    FROM cities_year_population
  )
  UNION
  (
    SELECT
      SUM(total) AS total,
      year,
      14 AS geo_id
    FROM cities_year_population
    GROUP BY year
  )
) AS source
WHERE year = {{year}} AND geo_id = {{geo_id}}
