# População

## POPULAÇẪO TOTAL POR CIDADE

```sql
SELECT ("source"."Adultos" + "source"."Idosos" + "source"."Crianças e Adolescentes") as "População", "city_id" as "Cidade", "name"  from
(SELECT
("public"."cities_year_population"."age_20_29" + "public"."cities_year_population"."age_30_39" + "public"."cities_year_population"."age_40_49" + "public"."cities_year_population"."age_50_59") AS "Adultos",
("public"."cities_year_population"."age_0_4" + "public"."cities_year_population"."age_5_9" + "public"."cities_year_population"."age_10_14" + "public"."cities_year_population"."age_15_19") AS "Crianças e Adolescentes",
("public"."cities_year_population"."age_60_69" + "public"."cities_year_population"."age_70_79" + "public"."cities_year_population"."age_80_or_more") AS "Idosos", "public"."cities_year_population"."city_id" as "city_id", "City"."name" as "name"
FROM "public"."cities_year_population"
LEFT JOIN "public"."cities" "City" ON "public"."cities_year_population"."city_id" = "City"."id") "source"
```

## Nascimentos por Cidade de residência

```sql
SELECT "public"."cities"."name", codmunres, COUNT(codmunres) FROM "public"."birth_registries"
LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
GROUP BY codmunres, "public"."cities"."name"
```

## Nascimentos por Cidade de nascimento

```sql
SELECT "public"."cities"."name", codmunnasc, COUNT(codmunnasc) FROM "public"."birth_registries"
LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunnasc"
GROUP BY codmunnasc, "public"."cities"."name"
```

## Taxa Bruta de Natalidade

```sql
SELECT "cod_cidade" as "Cidade","cidade","nascimentos", "population"."total", (CAST(nascimentos as FLOAT)/CAST(total as FLOAT)*100) as "Taxa Bruta de Natalidade" FROM(
    SELECT "public"."cities"."name" as "cidade", codmunres as "cod_cidade", COUNT(codmunres) as "nascimentos" FROM "public"."birth_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."birth_registries"."codmunres"
    GROUP BY codmunres, "public"."cities"."name") as "registros", "public"."cities_year_population" as "population"
where "population"."city_id" = "cod_cidade"
```

## Mortes por Cidade de Residencia

```sql
SELECT "public"."cities"."name" as "cidade", codmunres as "cod_cidade", COUNT(codmunres) as "mortes" FROM "public"."death_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."death_registries"."codmunres"
    GROUP BY codmunres, "public"."cities"."name")
```

## Taxa Bruta de Mortalidade

```sql
SELECT "cod_cidade" as "Cidade","cidade","mortes", "population"."total", (CAST("mortes" as FLOAT)/CAST(total as FLOAT)*100) as "Taxa Bruta de Mortalidade" FROM(
    SELECT "public"."cities"."name" as "cidade", codmunres as "cod_cidade", COUNT(codmunres) as "mortes" FROM "public"."death_registries"
    LEFT JOIN "public"."cities" ON "public"."cities"."id" = "public"."death_registries"."codmunres"
    GROUP BY codmunres, "public"."cities"."name") as "registros", "public"."cities_year_population" as "population"
where "population"."city_id" = "cod_cidade"
```
