# Razão Sexo

## RAZAO DE SEXOS POR CIDADE

```sql
SELECT CAST(SUM(male) AS FLOAT) / CAST(SUM(female) AS FLOAT) as "Razão", C.name, C.id AS "Cidade"
FROM cities_year_population as CYP
JOIN cities AS C ON CYP.city_id = C.id
GROUP BY C.id, CYP.city_id HAVING C.id = CYP.city_id
```

## RAZAO DE SEXOS POR MICRO REGIAO

```sql
SELECT CAST(SUM(male) AS FLOAT) / CAST(SUM(female) AS FLOAT) as "Razão", MICRO_REG.name as "Micro Região"
FROM cities_year_population as CYP
JOIN cities AS C ON CYP.city_id = C.id
JOIN microregions AS MICRO_REG ON C.microregion_id = MICRO_REG.id
GROUP BY C.microregion_id, MICRO_REG.id HAVING MICRO_REG.id = C.microregion_id
```

## RAZAO DE SEXOS POR MESO REGIAO

```sql
SELECT CAST(SUM(male) AS FLOAT) / CAST(SUM(female) AS FLOAT) as "Razão", MESO_REG.name as "Meso Região"
FROM cities_year_population as CYP
JOIN cities AS C ON CYP.city_id = C.id
JOIN microregions AS MICRO_REG ON C.microregion_id = MICRO_REG.id
JOIN mesoregions AS MESO_REG ON MICRO_REG.mesoregion_id = MESO_REG.id
GROUP BY MESO_REG.id, MICRO_REG.mesoregion_id HAVING MESO_REG.id = MICRO_REG.mesoregion_id
```
