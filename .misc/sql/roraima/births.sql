SELECT
  births AS "Nascimentos",
  year AS "Ano",
  geo_id AS "Estado ou Município"
FROM (
  (
    SELECT
      COUNT(*) AS births,
      year,
      codmunres AS geo_id
    FROM birth_registries
    GROUP BY year, codmunres
  )
  UNION
  (
    SELECT
      COUNT(*) AS births,
      year,
      14 AS geo_id
    FROM birth_registries
    GROUP BY year
  )
) AS source
WHERE year = {{year}} aND geo_id = {{geo_id}}
