
WITH references as (
  SELECT   pcl.relname AS tabla, 
           (SELECT pgcl1.relname FROM pg_class pgcl1 WHERE pgcl1.oid=pgc.confrelid) as ref
  FROM pg_constraint pgc, pg_class pcl
  WHERE ((pgc.contype = 'f') AND (pgc.conrelid = pcl.oid))
)
SELECT ref as mainTable, 
       string_Agg(tabla::text,' ') as FK_Dependencies 
FROM references group by mainTable;

