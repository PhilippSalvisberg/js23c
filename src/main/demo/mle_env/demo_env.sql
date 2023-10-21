create or replace mle env demo_env
    imports(
        'increase_salary' module increase_salary_mod,
        'validator'       module validator_mod,
        'util'            module util_mod
    )
    language options 'js.strict=true, js.console=false, js.polyglot-builtin=true';
