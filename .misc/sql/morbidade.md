# Morbidade

## Incidências

```sql
SELECT id, "doenças"."Casos" FROM cities
LEFT JOIN (
    SELECT disease_id, D.name AS "Doença", id_municip, C.name AS "Cidade",COUNT(*) AS "Casos" FROM morbidity_registries,diseases as D, cities as C
    WHERE morbidity_registries.disease_id = D.id AND C.id = id_municip AND disease_id = 'B05'
    GROUP BY disease_id, id_municip, D.name, C.name
) as "doenças" on id = "doenças".id_municip
```

## Taxa de incidência

```sql
SELECT id as "Cidade", "doenças"."casos" as "Casos","doenças"."incidencia" as "Incidência" FROM cities
LEFT JOIN (
    SELECT disease_id, D.name AS "Doença", id_municip, C.name AS "Cidade",COUNT(*) as "casos", CAST(COUNT(*) AS FLOAT) / CYP.total * 100000 AS "incidencia" FROM cities_year_population as CYP, morbidity_registries, diseases as D, cities as C
    WHERE morbidity_registries.disease_id = D.id AND C.id = id_municip AND CYP.city_id = C.id AND (disease_id IN ('B20','B21','B22','B23','B24'))
    GROUP BY disease_id, id_municip, D.name, C.name, CYP.total
) as "doenças" on id = "doenças".id_municip
```
