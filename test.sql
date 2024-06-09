select
    dependent_ns.nspname as dependent_schema,
    dependent_view.relname as dependent_view,
    source_ns.nspname as source_schema,
    source_table.relname as source_table,
    pg_attribute.attname as column_name
from warehouse.pg_catalog.pg_depend
inner join warehouse.pg_catalog.pg_rewrite on pg_depend.objid = pg_rewrite.oid

inner join warehouse.pg_catalog.pg_class as dependent_view
    on pg_rewrite.ev_class = dependent_view.oid

inner join warehouse.pg_catalog.pg_class as source_table
    on pg_depend.refobjid = source_table.oid

inner join warehouse.pg_catalog.pg_attribute
    on
        pg_depend.refobjid = pg_attribute.attrelid
        and pg_depend.refobjsubid = pg_attribute.attnum
inner join warehouse.pg_catalog.pg_namespace as dependent_ns
    on dependent_view.relnamespace = dependent_ns.oid

inner join warehouse.pg_catalog.pg_namespace as source_ns
    on source_table.relnamespace = source_ns.oid
where
    source_ns.nspname = 'my_schema'
    and source_table.relname = 'my_table'
    and pg_attribute.attnum > 0
    and pg_attribute.attname = 'my_column'
order by
    dependent_schema,
    dependent_view;
