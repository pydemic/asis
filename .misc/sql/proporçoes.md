# Proporções

## Proporção de menores de 5 anos de idade por cidades

```sql
SELECT CAST(age_0_4 AS FLOAT) / CAST(female AS FLOAT) * 100 AS "Proporção", C.id AS "Cidade"
FROM cities_year_population AS CYP
JOIN cities AS C ON CYP.city_id = C.id
GROUP BY CYP.age_0_4, C.id, CYP.female
```

## Proporção de menores de 5 ano de idade por micro região

```sql
SELECT CAST(SUM(age_0_4) AS FLOAT) / CAST(SUM(female) AS FLOAT) * 100 AS "Proporção", MICRO_REG.name AS "Micro Região"
FROM cities_year_population AS CYP
JOIN cities AS C ON CYP.city_id = C.id
JOIN microregions AS MICRO_REG ON C.microregion_id = MICRO_REG.id
GROUP BY MICRO_REG.id, MICRO_REG.name
```

## Proporção de idosos por cidade

```sql
SELECT CAST(age_60_69 + age_70_79 + age_80_or_more AS FLOAT) / total * 100 AS "Proporção", C.id AS "Cidade"
FROM cities_year_population AS CYP
JOIN cities AS C ON CYP.city_id = C.id
```
