# Mortalidade

## Mortalidade proporcional por idade

```sql
SELECT "public"."cities"."name" as "Município", codmunres as "Código Município", 
    COUNT(codmunres) as "Óbitos totais",
    COUNT(CASE WHEN idade > 0 THEN 1 END) as "Óbitos totais com Idade registrada",
    (CAST(COUNT(CASE WHEN idade <= 400 THEN 1 END) as FLOAT)/ COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "Menos de 1 ano",
    (CAST(COUNT(CASE WHEN (idade >= 401 and idade <= 404) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "1 a 4 anos",
    (CAST(COUNT(CASE WHEN (idade >= 405 and idade <= 409) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "5 a 9 anos",
    (CAST(COUNT(CASE WHEN (idade >= 410 and idade <= 419) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "10 a 19 anos",
    (CAST(COUNT(CASE WHEN (idade >= 420 and idade <= 439) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "20 a 39 anos",
    (CAST(COUNT(CASE WHEN (idade >= 440 and idade <= 459) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "40 a 59 anos",
    (CAST(COUNT(CASE WHEN (idade >= 460 and idade <= 479) THEN 1 END) as FLOAT)/  COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "60 a 79 anos",
    (CAST(COUNT(CASE WHEN (idade >= 480) THEN 1 END) as FLOAT)/ COUNT(CASE WHEN idade > 0 THEN 1 END) * 100) as "80+ anos"
FROM "public"."death_registries"
LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."death_registries"."codmunres"
JOIN cities AS C ON  codmunres = C.id
GROUP BY codmunres, "public"."cities"."name"

```

## Mortalidade proporcional por idade em menores de 1 ano de idade

```sql
SELECT
"Cidade",
"Crianças",
"Período neonatal precoce bruto",
"Período neonatal tardio bruto",
"Período pós neonatal bruto",
CASE WHEN("Crianças" > 0) THEN  CAST("Período neonatal precoce bruto" AS FLOAT) / "Crianças" END * 100 AS "Período neonatal precoce",
CASE WHEN("Crianças" > 0) THEN  CAST("Período neonatal tardio bruto" AS FLOAT) / "Crianças" END * 100 AS "Período neonatal tardio",
CASE WHEN("Crianças" > 0) THEN  CAST("Período pós neonatal bruto" AS FLOAT) / "Crianças" END * 100 AS "Período pós neonatal"
FROM (
    SELECT C.name as "Cidade",
        COUNT(CASE WHEN (idade > 0 and idade <= 400) THEN 1 END) as "Crianças",
        COUNT(CASE WHEN (idade > 0 and idade <= 206) THEN 1 END) as "Período neonatal precoce bruto",
        COUNT(CASE WHEN (idade > 207 and idade <= 227) THEN 1 END) as "Período neonatal tardio bruto",
        COUNT(CASE WHEN (idade > 227 and idade <= 400) THEN 1 END) as "Período pós neonatal bruto"
    FROM death_registries
    JOIN cities AS C ON  codmunres = C.id
    GROUP BY codmunres, C.name
) AS bruto
```

## Taxa de mortalidade infantil

```sql
SELECT codmunres as "Código Municipio", "Nascimentos", "teste"."Cidade", "Obitos de Crianças", (CAST("Obitos de Crianças" as FLOAT)/"Nascimentos"*1000) as "Taxa de Mortalidade Infantil" FROM (
    SELECT "public"."cities"."name", "public"."birth_registries"."codmunres", COUNT("public"."birth_registries"."codmunres") as "Nascimentos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "public"."cities"."name"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Cidade",
        COUNT(CASE WHEN (idade > 0 and idade <= 400) THEN 1 END) as "Obitos de Crianças"
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id)"teste"
ON "teste"."teste_id" = "codmunres"
JOIN cities AS C ON  codmunres = C.id
```

## Taxa de mortalidade neonatal precoce

```sql
SELECT "nascimentos"."Nome Cidade", "nascimentos"."nascidos", "nascimentos"."Cidade","Obitos neonatal precoce", (CAST("Obitos neonatal precoce" as FLOAT)/"nascidos"*1000) as "Taxa de Mortalidade Neonatal Precoce" FROM (
    SELECT "public"."cities"."name" as "Nome Cidade", "public"."birth_registries"."codmunres" as "Cidade", COUNT("public"."birth_registries"."codmunres") as "nascidos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "Nome Cidade"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Nome Cidade",
        COUNT(CASE WHEN (idade > 0 and idade <= 206) THEN 1 END) as "Obitos neonatal precoce"
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id) "teste" ON "teste"."teste_id" = "Cidade"
```

## Taxa de mortalidade neonatal tardia

```sql
SELECT "nascimentos"."Nome Cidade", "nascimentos"."nascidos", "nascimentos"."Cidade","Obitos neonatal tardio", (CAST("Obitos neonatal tardio" as FLOAT)/"nascidos"*1000) as "Taxa de Mortalidade Neonatal Tardia" FROM (
    SELECT "public"."cities"."name" as "Nome Cidade", "public"."birth_registries"."codmunres" as "Cidade", COUNT("public"."birth_registries"."codmunres") as "nascidos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "Nome Cidade"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Nome Cidade",
        COUNT(CASE WHEN (idade > 207 and idade <= 227) THEN 1 END) as "Obitos neonatal tardio"
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id) "teste" ON "teste"."teste_id" = "Cidade"
```

## Taxa de mortalidade pós-neonatal

```sql
SELECT "nascimentos"."Nome Cidade", "nascimentos"."nascidos", "nascimentos"."Cidade","Obitos pos neonatal", (CAST("Obitos pos neonatal" as FLOAT)/"nascidos"*1000) as "Taxa de Mortalidade Pós-Neonatal" FROM (
    SELECT "public"."cities"."name" as "Nome Cidade", "public"."birth_registries"."codmunres" as "Cidade", COUNT("public"."birth_registries"."codmunres") as "nascidos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "Nome Cidade"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Nome Cidade",
        COUNT(CASE WHEN (idade > 227 and idade <= 400) THEN 1 END) as "Obitos pos neonatal"
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id) "teste" ON "teste"."teste_id" = "Cidade"
```

## Taxa de mortalidade na infância

```sql
SELECT "nascimentos"."Nome Cidade", "nascimentos"."nascidos", "nascimentos"."Cidade","Obitos Infancia", (CAST("Obitos Infancia" as FLOAT)/"nascidos"*1000) as "Taxa de Mortalidade na Infância" FROM (
    SELECT "public"."cities"."name" as "Nome Cidade", "public"."birth_registries"."codmunres" as "Cidade", COUNT("public"."birth_registries"."codmunres") as "nascidos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "Nome Cidade"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Nome Cidade",
        COUNT(CASE WHEN (idade > 227 and idade < 405) THEN 1 END) as "Obitos Infancia"
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id) "teste" ON "teste"."teste_id" = "Cidade"

SELECT *, (CAST("Obitos Infancia" as FLOAT)/"nascidos"*1000) as "Taxa de Mortalidade na Infancia" FROM (
    SELECT "public"."cities"."name", "public"."birth_registries"."codmunres", COUNT("public"."birth_registries"."codmunres") as "nascidos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY "public"."birth_registries"."codmunres", "public"."cities"."name"
) "nascimentos"
LEFT JOIN (
    SELECT C.id as "teste_id", C.name as "Cidade",
    FROM death_registries
    LEFT JOIN cities AS C ON C.id = death_registries.codmunres
    GROUP BY death_registries.codmunres, C.name, C.id) "teste" ON "teste"."teste_id" = "codmunres"
```

## Join de tabelas: causas, mortes, blocos, sub doenças e doenças

```sql
SELECT "public"."death_registries"."id", "public"."death_registries"."disease_id", causabas_o, chapter_id, block_id, "Sub Diseases"."id" as "sub_diseases id"
FROM "public"."death_registries"
LEFT JOIN "public"."block_diseases" "Block Diseases" ON "public"."death_registries"."disease_id" = "Block Diseases"."disease_id"
LEFT JOIN "public"."blocks" "Block" ON "Block Diseases"."block_id" = "Block"."id" LEFT JOIN "public"."chapters" "Chapter" ON "Block"."chapter_id" = "Chapter"."id"
LEFT JOIN "public"."sub_diseases" "Sub Diseases" ON "public"."death_registries"."sub_disease_id" = "Sub Diseases"."id"
LIMIT 1048576
```

## Proporção de óbitos por causas mal definidas

```sql
SELECT "CT_ID" AS "Código Município", "Município", "mal_def_total" as "Total de óbitos mal definidos", "total_mortes" as "Total de Óbitos", CAST("mal_def_total" AS FLOAT) / "total_mortes" * 100 AS "Proporção" FROM (
    SELECT CT.name AS "Município", COUNT(CH.id) AS "mal_def_total", CT.id AS "CT_ID" FROM death_registries
    JOIN cities AS CT ON CT.id = death_registries.codmunres
    JOIN block_diseases AS BD ON BD.disease_id = death_registries.disease_id
    JOIN blocks AS B ON B.id = BD.block_id
    JOIN chapters AS CH ON CH.id = B.chapter_id
    WHERE CH.id LIKE 'XVIII'
    GROUP BY CH.id, CT.name, CT.id
) AS "mal_def"
LEFT JOIN (
    SELECT COUNT(death_registries.codmunres) AS "total_mortes", CT.id AS "INNER_CT" FROM death_registries
    JOIN cities AS CT ON CT.id = death_registries.codmunres
    GROUP BY CT.id
) AS "total mortes"
ON "total mortes"."INNER_CT" = "mal_def"."CT_ID"
```

## Proporção de óbitos por doença diarréica aguda em menores de 5 anos de idade

```sql
SELECT "criancas_mortes_totais_diarreia"."city_id" as "Código Município","criancas_mortes_totais_diarreia"."value" as "Óbitos totais por doença diarréica em menores de 5 anos",  "criancas_mortes_totais_def"."value" as "Óbitos totais em menores de 5 anos com causa definida", "criancas_mortes_totais_diarreia"."Cidade", CAST("criancas_mortes_totais_diarreia"."value" AS FLOAT) / "criancas_mortes_totais_def"."value" * 100 AS "Proporção" FROM (
    SELECT CT.name AS "Cidade", COUNT(death_registries.codmunres) AS "value", CT.id AS "city_id" FROM death_registries
    JOIN cities AS CT ON CT.id = death_registries.codmunres
    JOIN block_diseases AS BD ON BD.disease_id = death_registries.disease_id
    WHERE BD.block_id LIKE 'A00-A09' AND death_registries.idade < 405
    GROUP BY BD.id, CT.name, CT.id
) AS "criancas_mortes_totais_diarreia"
LEFT JOIN (
    SELECT "city_id", "Cidade", SUM(CASES) AS "value" FROM (
        SELECT CT.name AS "Cidade", COUNT(death_registries.codmunres) as CASES, CT.id AS "city_id" FROM death_registries
        JOIN cities AS CT ON CT.id = death_registries.codmunres
        JOIN block_diseases AS BD ON BD.disease_id = death_registries.disease_id
        JOIN blocks AS B ON B.id = BD.block_id
        JOIN chapters AS CH ON CH.id = B.chapter_id
        WHERE CH.id NOT LIKE 'XVIII' AND death_registries.idade < 405
        GROUP BY BD.id, CT.name, CT.id
    ) AS tmp
    GROUP BY "city_id", "Cidade"
)AS "criancas_mortes_totais_def"
ON "criancas_mortes_totais_def"."city_id" = "criancas_mortes_totais_diarreia"."city_id"
```

## Proporção de óbitos por infecção respiratória aguda em menores de 5 anos de idade

```sql
SELECT criancas_mortes_totais_def."Cidade" as "Município",COUNT(criancas_mortes_totais_respiratoria.codmunres) as "Óbitos em menores de 5 anos por infecção respiratória aguda","criancas_mortes_totais_def"."TOTAL_CASES" as "Óbitos de menores de 5 anos com causas definidas", COUNT(criancas_mortes_totais_respiratoria.codmunres) / CAST("criancas_mortes_totais_def"."TOTAL_CASES" AS FLOAT) * 100 AS "Proporção" FROM (
        SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
        WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id AND block_diseases.block_id IN ('J00-J06', 'J09-J18', 'J20-J22') AND death_registries.idade < 405
        GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS "criancas_mortes_totais_respiratoria"
LEFT JOIN (
    SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) as "TOTAL_CASES", CT.id AS "city_id" FROM (
            SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
            WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id
            GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
        ) AS chapters
    JOIN cities AS CT ON CT.id = chapters.codmunres
    WHERE chapters.chapter_id NOT LIKE 'XVIII' AND chapters.idade < 405
    GROUP BY CT.name, CT.id, chapters.codmunres
) AS "criancas_mortes_totais_def" ON criancas_mortes_totais_respiratoria.codmunres = "criancas_mortes_totais_def"."city_id"
JOIN cities AS C ON "criancas_mortes_totais_respiratoria".codmunres = C.id
GROUP BY criancas_mortes_totais_respiratoria.codmunres, "criancas_mortes_totais_def"."TOTAL_CASES", criancas_mortes_totais_def."Cidade"

```

## Taxa de mortalidade específica por doenças do aparelho circulatório

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
WHERE chapters.chapter_id LIKE 'IX'
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```

## Taxa de mortalidade específica por causas externas

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
WHERE chapters.chapter_id LIKE 'XX'
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```

## Taxa de mortalidade específica por neoplasias malignas

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id AND (block_diseases.block_id LIKE 'C00-C97' OR block_diseases.disease_id LIKE 'D46')
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```

## Taxa de mortalidade específica por diabete melito

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id AND block_diseases.block_id LIKE 'E10-E14'
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```

## Taxa de mortalidade específica por AIDS

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id AND block_diseases.block_id LIKE 'B20-B24'
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```

## Taxa de mortalidade específica por afecções originadas no período perinatal

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST("total_nascidos"."value" AS FLOAT) * 1000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
LEFT JOIN (
    SELECT "public"."cities"."name", codmunres, COUNT(codmunres) AS "value" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY codmunres, "public"."cities"."name"
) AS "total_nascidos" ON "total_nascidos".codmunres = chapters.codmunres
WHERE chapters.chapter_id LIKE 'XVI' AND chapters.idade < 400
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total, "total_nascidos"."value"
```

## Taxa de mortalidade específica por doenças transmissíveis

```sql
SELECT CT.name AS "Cidade", COUNT(chapters.codmunres) / CAST(CYP.total AS FLOAT) * 100000 as "Taxa", CT.id AS "city_id" FROM (
    SELECT death_registries.idade, death_registries.codmunres, death_registries.disease_id, blocks.chapter_id FROM death_registries, block_diseases, blocks
    WHERE death_registries.disease_id = block_diseases.disease_id AND block_diseases.block_id = blocks.id
    GROUP BY death_registries.disease_id,  blocks.chapter_id, death_registries.codmunres, death_registries.idade
) AS chapters
JOIN cities AS CT ON CT.id = chapters.codmunres
JOIN cities_year_population AS CYP ON CYP.city_id = CT.ID
WHERE chapters.chapter_id LIKE 'I'
GROUP BY CT.name, CT.id, chapters.codmunres, CYP.total
```
