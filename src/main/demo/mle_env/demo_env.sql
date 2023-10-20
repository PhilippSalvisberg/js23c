create or replace mle env demo_env
    imports(
        'validator' module validator_mod,
        'util' module util
    )
    language options 'js.strict=true, js.console=false, js.polyglot-builtin=true';
