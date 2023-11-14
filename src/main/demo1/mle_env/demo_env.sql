create or replace mle env demo_env
    imports(
        'create_temp_table' module create_temp_table_mod,
        'increase_salary'   module increase_salary_mod,
        'sql-assert'        module sql_assert_mod,
        'validator'         module validator_mod,
        'util'              module util_mod
    )
    language options 'js.strict=true, js.console=false, js.polyglot-builtin=true';
