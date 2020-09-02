# Mortalidade

1. [Dados geográficos via IBGE](https://servicodados.ibge.gov.br/api/docs)
1. [Regiões de saúde via SESAU/RR](https://www.saude.rr.gov.br/)
1. [População residente via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0206&id=6942)
1. [Nascimentos via SINASC](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sinasc/)
1. [Óbitos via SIM](http://svs.aids.gov.br/dantps/centrais-de-conteudos/dados-abertos/sim/)
1. [Morbidades via DATASUS](http://www2.datasus.gov.br/DATASUS/index.php?area=0901&item=1&acao=41)
1. [Indicadores de doenças via OMS CID-10 2015](https://icd.who.int/browse10/2015/en)

## Taxa de mortalidade infantil por município

- ID: `12`
- Fontes: `[1,4,5]`
- Descrição: Óbitos de menores de 1 ano dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  city_name AS "Município",
  child_death_registries_count AS "Óbitos de idade menor que 1 ano",
  birth_registries_count AS "Nascimentos",
  CAST(child_death_registries_count AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT
    id,
    name AS city_name
  FROM cities
) AS C
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade > 0 AND idade <= 400 THEN 1 END) AS child_death_registries_count
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
```

## Taxa de mortalidade infantil por município - Mapa

- ID: `25`
- Fontes: `[1,4,5]`
- Descrição: Óbitos de menores de 1 ano dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  id AS "Município",
  CAST(child_death_registries_count AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade > 0 AND idade <= 400 THEN 1 END) AS child_death_registries_count
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
LEFT JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
```

## Taxa de mortalidade neonatal precoce por município

- ID: `15`
- Fontes: `[1,4,5]`
- Descrição: Óbitos de menores de 6 dias de idade dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  id AS "Município",
  CAST(early_neonatal_deaths AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade > 0 AND idade <= 206 THEN 1 END) AS early_neonatal_deaths
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
WHERE early_neonatal_deaths > 0 AND birth_registries_count > 0
```

## Taxa de mortalidade neonatal tardia por município

- ID: `16`
- Fontes: `[1,4,5]`
- Descrição: Óbitos entre 7 e 27 dias de idade dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  id AS "Município",
  CAST(late_neonatal_deaths AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade >= 207 AND idade <= 227 THEN 1 END) AS late_neonatal_deaths
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
WHERE late_neonatal_deaths > 0 AND birth_registries_count > 0
```

## Taxa de mortalidade pós-neonatal por município

- ID: `17`
- Fontes: `[1,4,5]`
- Descrição: Óbitos entre 28 e 364 dias de idade dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  id AS "Município",
  CAST(post_neonatal_deaths AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade >= 228 AND idade <= 400 THEN 1 END) AS post_neonatal_deaths
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
WHERE post_neonatal_deaths > 0 AND birth_registries_count > 0
```

## Taxa de mortalidade na infância por município

- ID: `18`
- Fontes: `[1,4,5]`
- Descrição: Óbitos de menores de 5 anos de idade dividido por nascimentos, multiplicado por 100

```sql
SELECT
  id AS "Município",
  CAST(child_deaths AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 100.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade > 0 AND idade <= 405 THEN 1 END) AS child_deaths
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
WHERE child_deaths > 0 AND birth_registries_count > 0
```

## Proporção de óbitos por causas mal definidas por município

- ID: `19`
- Fontes: `[1,5,7]`
- Descrição: Óbitos CID-10 R00-R99 dividido por óbitos, multiplicado por 100

```sql
SELECT
  id AS "Município",
  CAST(deaths AS FLOAT) / CAST(death_registries_count AS FLOAT) * 100.0 AS "Proporção"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id = 'XVIII'
  GROUP BY city_id
) AS source ON C.id = source.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS death_registries_count
  FROM death_registries
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
WHERE deaths > 0 AND death_registries_count > 0
```

## Proporção de óbitos por doença diarréica aguda em menores de 5 anos de idade por município

- ID: `26`
- Fontes: `[1,5,7]`
- Descrição: Óbitos CID-10 A00-A09 em menores de 5 anos dividido por óbitos em menores de 5 anos exceto CID-10 R00-R99, multiplicado por 100

```sql
SELECT
  id AS "Município",
  CAST(child_deaths AS FLOAT) / CAST(child_death_registries_count AS FLOAT) * 100.0 AS "Proporção"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade < 405 THEN 1 END) AS child_deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  WHERE B.id = 'A00-A09'
  GROUP BY city_id
) AS source ON C.id = source.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade < 405 THEN 1 END) AS child_death_registries_count
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id != 'XVIII'
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
WHERE child_deaths > 0 AND child_death_registries_count > 0
```

## Proporção de óbitos por infecção respiratória aguda em menores de 5 anos de idade por município

- ID: `24`
- Fontes: `[1,5,7]`
- Descrição: Óbitos CID-10 J00-J22 em menores de 5 anos dividido por óbitos em menores de 5 anos exceto CID-10 R00-R99, multiplicado por 100

```sql
SELECT
  id AS "Município",
  CAST(child_deaths AS FLOAT) / CAST(child_death_registries_count AS FLOAT) * 100.0 AS "Proporção"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade < 405 THEN 1 END) AS child_deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  WHERE B.id IN ('J00-J06', 'J09-J18', 'J20-J22')
  GROUP BY city_id
) AS source ON C.id = source.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(CASE WHEN idade < 405 THEN 1 END) AS child_death_registries_count
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id != 'XVIII'
  GROUP BY city_id
) AS DR ON C.id = DR.city_id
WHERE child_deaths > 0 AND child_death_registries_count > 0
```

## Taxa de mortalidade específica por doenças do aparelho circulatório por município

- ID: `51`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 I00-I99 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id = 'IX'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```

## Taxa de mortalidade específica por causas externas por município

- ID: `56`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 V01-Y98 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id = 'XX'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```

## Taxa de mortalidade específica por neoplasias malignas por município

- ID: `57`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 C00-C97 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  WHERE B.id = 'C00-C97'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```

## Taxa de mortalidade específica por diabete melito por município

- ID: `55`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 E10-E14 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  WHERE B.id = 'E10-E14'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```

## Taxa de mortalidade específica por HIV/AIDS por município

- ID: `54`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 B20-B24 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  WHERE B.id = 'B20-B24'
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```

## Taxa de mortalidade específica por afecções originadas no período perinatal por município

- ID: `53`
- Fontes: `[1,4,5,7]`
- Descrição: Óbitos CID-10 P00-P96 dividido por nascimentos, multiplicado por 1.000

```sql
SELECT
  id AS "Município",
  CAST(deaths AS FLOAT) / CAST(birth_registries_count AS FLOAT) * 1000.0 AS "Taxa"
FROM (
  SELECT id
  FROM cities
) AS C
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id = 'XVI'
  GROUP BY city_id
) AS source ON C.id = source.city_id
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS birth_registries_count
  FROM birth_registries
  GROUP BY city_id
) AS BR ON C.id = BR.city_id
WHERE deaths > 0 AND birth_registries_count > 0
```

## Taxa de mortalidade específica por doenças transmissíveis por município

- ID: `52`
- Fontes: `[1,3,5,7]`
- Descrição: Óbitos CID-10 A00-B99, G00-G03, J00-J22 dividido por população residente, multiplicado por 100.000

```sql
SELECT
  CYP.city_id AS "Município",
  CAST(deaths AS FLOAT) / CAST(total AS FLOAT) * 100000.0 AS "Taxa"
FROM (
  SELECT
    city_id,
    total
  FROM cities_year_population
) AS CYP
INNER JOIN (
  SELECT
    codmunres AS city_id,
    COUNT(codmunres) AS deaths
  FROM death_registries AS DR
  LEFT JOIN block_diseases AS BD ON DR.disease_id = BD.disease_id
  LEFT JOIN blocks AS B ON BD.block_id = B.id
  LEFT JOIN chapters AS CH ON B.chapter_id = CH.id
  WHERE CH.id = 'I' OR B.id IN ('J00-J06', 'J09-J18', 'J20-J22') OR BD.disease_id IN ('G00', 'G01', 'G02', 'G03')
  GROUP BY city_id
) AS source ON CYP.city_id = source.city_id
WHERE deaths > 0
```
