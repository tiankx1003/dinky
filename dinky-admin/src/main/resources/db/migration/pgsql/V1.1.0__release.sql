
-- 创建存储过程/函数 用于添加表字段时判断字段是否存在, 如果字段不存在则添加字段, 如果字段存在则不执行任何操作,避免添加重复字段时抛出异常,从而终止Flyway执行, 在 Flyway 执行时, 如果你需要增加字段,必须使用该存储过程
-- Create a stored procedure to determine whether a field exists when adding table fields. If the field does not exist, add it. If the field exists, do not perform any operations to avoid throwing exceptions when adding duplicate fields. When executing in Flyway, if you need to add a field, you must use this stored procedure

CREATE OR REPLACE FUNCTION add_column_if_not_exists(model text, p_table_name text, p_column_name text, p_data_type text, p_default_value text, p_comment text)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
      SELECT 1
      FROM   information_schema.columns
      WHERE  table_schema = model
      AND    table_name = p_table_name
      AND    column_name = p_column_name
   ) THEN
        EXECUTE format('ALTER TABLE %I ADD COLUMN %I %s DEFAULT %s', p_table_name, p_column_name, p_data_type, p_default_value);
        EXECUTE format('COMMENT ON COLUMN %I.%I IS %L', p_table_name, p_column_name, p_comment);
        RAISE NOTICE 'Column % added to table %.', p_column_name, p_table_name;
ELSE
      RAISE NOTICE 'Column % already exists in table %.', p_column_name, p_table_name;
END IF;
END;
$$ LANGUAGE plpgsql;



update public.dinky_sys_menu
set "path"='/registration/alert/rule',
    "component"='./RegCenter/Alert/AlertRule',
    "perms"='registration:alert:rule',
    "parent_id"=12
where "id" = 116;

update "public"."dinky_sys_menu"
set "path"='/registration/alert/rule/add',
    "perms"='registration:alert:rule:add'
where "id" = 117;

update public.dinky_sys_menu
set "path"='/registration/alert/rule/delete',
    "perms"='registration:alert:rule:delete'
where "id" = 118;

update public.dinky_sys_menu
set "path"='/registration/alert/rule/edit',
    "perms"='registration:alert:rule:edit'
where "id" = 119;



-- Increase class_name column's length from 50 to 100.
ALTER TABLE public.dinky_udf_manage ALTER COLUMN class_name TYPE VARCHAR(100);
COMMENT ON COLUMN public.dinky_udf_manage."class_name" IS 'Complete class name';


SELECT add_column_if_not_exists('public','dinky_task', 'first_level_owner', 'int', 'null', 'primary responsible person id');
SELECT add_column_if_not_exists('public','dinky_task', 'second_level_owners', 'varchar(128)', 'null', 'list of secondary responsible persons ids');


update public.dinky_task set "first_level_owner" = "creator";
