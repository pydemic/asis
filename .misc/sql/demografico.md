# Dados Demográficos

1. [Dados geográficos via IBGE](https://servicodados.ibge.gov.br/api/docs)
1. [Regiões de saúde via SESAU/RR](https://www.saude.rr.gov.br/)
1. [População residente via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0206&id=6942)
1. [Nascimentos via SINASC](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sinasc/)
1. [Óbitos via SIM](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sim/)
1. [Morbidades via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0901&item=1&acao=41)
1. [Indicadores de doenças via OMS CID-10 2015](https://icd.who.int/browse10/2015/en)

## População total por município

- ID: `7`
- Fontes: `[1,3]`
- Descrição: Total de população residente

```sql
SELECT
  city_id AS "Município",
  total AS "População residente"
FROM cities_year_population
```

## Razão de sexos por município

- ID: `3`
- Fontes: `[1,3]`
- Descrição: População residente masculina dividido por população residente feminina, multiplicado por 100

```sql
SELECT
  city_id AS "Município",
  (CAST(male AS FLOAT) / CAST(female AS FLOAT)) * 100.0 AS "Razão"
FROM cities_year_population
```

## Razão de sexos por região de saúde

- ID: `2`
- Fontes: `[1,3]`
- Descrição: População residente masculina dividido pela população residente feminina, multiplicado por 100

```sql
SELECT
  health_region_name AS "Região de saúde",
  male AS "População residente masculina",
  female AS "População residente feminina",
  (CAST(male AS FLOAT) / CAST(female as FLOAT)) * 100.0 AS "Razão"
FROM (
  SELECT
    HR.name AS health_region_name,
    SUM(CYP.male) AS male,
    SUM(CYP.female) AS female
  FROM cities_year_population AS CYP
  INNER JOIN cities AS C ON CYP.city_id = C.id
  INNER JOIN health_regions AS HR ON C.health_region_id = HR.id
  GROUP BY HR.id
) AS source
```

## Proporção de menores de 5 anos de idade na população por município

- ID: `4`
- Fontes: `[1,3]`
- Descrição: População residente menor de 5 anos dividido por população residente feminina, multiplicado por 100

```sql
SELECT
  city_id AS "Município",
  (CAST(age_0_4 AS FLOAT) / CAST(female AS FLOAT)) * 100.0 AS "Proporção"
FROM cities_year_population
```

## Proporção de idosos na população por município

- ID: `6`
- Fontes: `[1,3]`
- Descrição: População residente maior ou igual a 60 anos dividido por população residente, multiplicado por 100

```sql
SELECT
  city_id AS "Município",
  (CAST(age_60_69 + age_70_79 + age_80_or_more AS FLOAT) / CAST(total AS FLOAT)) * 100.0 AS "Proporção"
FROM cities_year_population
```

## Taxa bruta de natalidade por município

- ID: `8`
- Fontes: `[1,3,4]`
- Descrição: Nascidos vivos dividido por população residente, multiplicado por 100

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(birth_registries_count AS FLOAT) / CAST(total AS FLOAT)) * 100.0 AS "Taxa"
FROM cities_year_population AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON CYP.city_id = BR.city_id
```

## Taxa bruta de mortalidade por município

- ID: `9`
- Fontes: `[1,3,5]`
- Descrição: Óbitos dividido por população residente, multiplicado por 1.000

```sql
SELECT
  CYP.city_id AS "Município",
  (CAST(death_registries_count AS FLOAT) / CAST(total AS FLOAT)) * 1000.0 AS "Taxa"
FROM cities_year_population AS CYP
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS death_registries_count
  FROM death_registries
  GROUP BY city_id
) AS DR ON CYP.city_id = DR.city_id
```

## Taxa de mortalidade proporcional por idade por município

- ID: `10`
- Fontes: `[1,5]`
- Descrição: Óbitos de uma faixa etária entre X e Y anos dividido por óbitos (excluídos os de idade ignorada), multiplicado por 100

```sql
SELECT
  city_name AS "Município",
  death_registries_count AS "Óbitos",
  death_registries_count_with_age AS "Óbitos com registro de idade",
  age_lesser_than_1_deaths AS "Óbitos de idade menor que 1 ano",
  age_1_4_deaths AS "Óbitos de idade entre 1 e 4 anos",
  age_5_9_deaths AS "Óbitos de idade entre 5 e 9 anos",
  age_10_19_deaths AS "Óbitos de idade entre 10 e 19 anos",
  age_20_39_deaths AS "Óbitos de idade entre 20 e 39 anos",
  age_40_59_deaths AS "Óbitos de idade entre 40 e 59 anos",
  age_60_79_deaths AS "Óbitos de idade entre 60 e 79 anos",
  age_80_or_more_deaths AS "Óbitos de idade maior que 80 anos",
  CAST(age_lesser_than_1_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "< 1 ano",
  CAST(age_1_4_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "1 a 4 anos",
  CAST(age_5_9_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "5 a 9 anos",
  CAST(age_10_19_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "10 a 19 anos",
  CAST(age_20_39_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "20 a 39 anos",
  CAST(age_40_59_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "40 a 59 anos",
  CAST(age_60_79_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "60 a 79 anos",
  CAST(age_80_or_more_deaths AS FLOAT) / CAST(death_registries_count_with_age AS FLOAT) * 100.0 AS "80+ anos"
FROM (
  SELECT
    id,
    name AS city_name
  FROM cities
) AS C
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS death_registries_count,
    COUNT(CASE WHEN idade > 0 THEN 1 END) AS death_registries_count_with_age,
    COUNT(CASE WHEN idade <= 400 THEN 1 END) AS age_lesser_than_1_deaths,
    COUNT(CASE WHEN idade >= 401 AND idade <= 404 THEN 1 END) AS age_1_4_deaths,
    COUNT(CASE WHEN idade >= 405 AND idade <= 409 THEN 1 END) AS age_5_9_deaths,
    COUNT(CASE WHEN idade >= 410 AND idade <= 419 THEN 1 END) AS age_10_19_deaths,
    COUNT(CASE WHEN idade >= 420 AND idade <= 439 THEN 1 END) AS age_20_39_deaths,
    COUNT(CASE WHEN idade >= 440 AND idade <= 459 THEN 1 END) AS age_40_59_deaths,
    COUNT(CASE WHEN idade >= 460 AND idade <= 479 THEN 1 END) AS age_60_79_deaths,
    COUNT(CASE WHEN idade >= 480 THEN 1 END) AS age_80_or_more_deaths
  FROM death_registries
  GROUP BY codmunres
) AS DR ON C.id = DR.city_id
```

## Taxa de mortalidade proporcional por idade em menores de 1 ano de idade por município

- ID: `11`
- Fontes: `[1,5]`
- Descrição: Óbitos de uma faixa etária entre X e Y dias para menores de 1 ano dividido por óbitos de menores de 1 ano, multiplicado por 100

```sql
SELECT
  city_name AS "Município",
  child_death_registries_count AS "Óbitos de idade menor que 1 ano",
  early_neonatal_deaths AS "Óbitos no período neonatal precoce",
  late_neonatal_deaths AS "Óbitos no período neonatal tardio",
  post_neonatal_deaths AS "Óbitos no período pós-neonatal",
  CAST(early_neonatal_deaths AS FLOAT) / CAST(child_death_registries_count AS FLOAT) * 100.0 AS "Período neonatal precoce",
  CAST(late_neonatal_deaths AS FLOAT) / CAST(child_death_registries_count AS FLOAT) * 100.0 AS "Período neonatal tardio",
  CAST(post_neonatal_deaths AS FLOAT) / CAST(child_death_registries_count AS FLOAT) * 100.0 AS "Período pós-neonatal"
FROM (
  SELECT
    id,
    name AS city_name
  FROM cities
) AS C
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade > 0 AND idade <= 400 THEN 1 END) AS child_death_registries_count,
    COUNT(CASE WHEN idade > 0 AND idade <= 206 THEN 1 END) AS early_neonatal_deaths,
    COUNT(CASE WHEN idade >= 207 AND idade <= 227 THEN 1 END) AS late_neonatal_deaths,
    COUNT(CASE WHEN idade >= 228 AND idade <= 400 THEN 1 END) AS post_neonatal_deaths
  FROM death_registries
  GROUP BY codmunres
) AS DR ON C.id = DR.city_id
```
