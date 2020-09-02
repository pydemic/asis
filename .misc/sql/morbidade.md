# Morbidade

1. [Dados geográficos via IBGE](https://servicodados.ibge.gov.br/api/docs)
1. [Regiões de saúde via SESAU/RR](https://www.saude.rr.gov.br/)
1. [População residente via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0206&id=6942)
1. [Nascimentos via SINASC](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sinasc/)
1. [Óbitos via SIM](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sim/)
1. [Morbidades via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0901&item=1&acao=41)
1. [Indicadores de doenças via OMS CID-10 2015](https://icd.who.int/browse10/2015/en)

## Incidência de sarampo por município

- ID: `27`
- Fontes: `[1,6,7]`
- Descrição: CID-10 B05

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'B05'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de difteria por município

- ID: `28`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A36

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'A36'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de coqueluche por município

- ID: `29`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A37

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'A37'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de tétano neonatal por município

- ID: `30`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A33

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'A33'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de tétano, exceto o tétano neonatal por município

- ID: `31`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A34

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'A34'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de febre amarela, silvestre e urbana por município

- ID: `32`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A95

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'A95'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de mordedura provocada por cão por município

- ID: `33`
- Fontes: `[1,6,7]`
- Descrição: CID-10 W54

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'W54'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de hepatite B

- ID: `34`
- Fontes: `[1,6,7]`
- Descrição: CID-10 B16

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.disease_id = 'B16'
  GROUP BY city_id
) AS source ON C.id = source.city_id
WHERE incidence > 0
UNION ALL SELECT '0', 0
```

## Incidência de hepatite aguda C

- ID: `35`
- Fontes: `[1,6,7]`
- Descrição: CID-10 B17.1

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE sub_disease_id = 'B17.1'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de cólera por município

- ID: `36`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A00

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A00'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de febre hemorrágica da dengue por município

- ID: `37`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A91

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A91'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de sífilis congênita em menores de 1 ano de idade por município

- ID: `38`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A50

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A50'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de rubéola por município

- ID: `39`
- Fontes: `[1,6,7]`
- Descrição: CID-10 B06

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'B06'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de síndrome da rubéola congênita por município

- ID: `40`
- Fontes: `[1,6,7]`
- Descrição: CID-10 P35.0

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE sub_disease_id = 'P35.0'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de doença meningocócica por município

- ID: `41`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A39

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A39'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de meningite (bacteriana, viral, inclui a meningocócica) por município

- ID: `43`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A17.0, A39.0, A87, G00-G03

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id IN ('A87', 'G00', 'G01', 'G02', 'G03') OR sub_disease_id IN ('A17.0', 'A39.0')
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Incidência de leptospirosis por município

- ID: `42`
- Fontes: `[1,6,7]`
- Descrição: CID-10 A27

```sql
SELECT
  id AS "Município",
  incidence AS "Incidência"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A27'
  GROUP BY city_id
) AS source ON C.id = source.city_id
UNION ALL SELECT '0', 0
```

## Taxa de incidência de HIV/AIDS por município

- ID: `44`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 B20-B24 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.block_id = 'B20-B24'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```

## Taxa de incidência de tuberculose por município

- ID: `45`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 A15-A19 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  LEFT JOIN block_diseases AS BD ON MR.disease_id = BD.disease_id
  WHERE BD.block_id = 'A15-A19'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```

## Taxa de incidência de dengue por município

- ID: `46`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 A90-A91 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE MR.disease_id IN ('A90', 'A91')
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```

## Taxa de incidência de leishmaniose tegumentar americana por município

- ID: `47`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 B55.1, B55.2 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE sub_disease_id IN ('B55.1', 'B55.2')
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```

## Taxa de incidência de leishmaniose visceral por município

- ID: `48`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 B55.0 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE sub_disease_id = 'B55.0'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```

## Taxa de incidência de hanseníase por município

- ID: `49`
- Fontes: `[1,3,6,7]`
- Descrição: Morbidade de CID-10 A30 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(incidence AS FLOAT) / CAST(total AS FLOAT)) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    id_municip AS city_id,
    COUNT(id_municip) AS incidence
  FROM morbidity_registries AS MR
  WHERE disease_id = 'A30'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE incidence > 0
```
