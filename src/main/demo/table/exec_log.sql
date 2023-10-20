-- make script re-runnable
create table if not exists exec_log (
    -- columns populated before execution of stmt (insert)
    log_id                                integer           generated always as identity not null primary key,
    start_time                            timestamp         default on null systimestamp not null,
    scenario                              varchar2(50 char) not null,
    run                                   integer           not null,
    no_of_calls                           integer           not null,
    stmt                                  clob              not null,
    start_db_time                         integer           not null, -- centi-seconds
    start_session_uga_memory_max          integer           not null, -- bytes
    start_session_pga_memory_max          integer           not null, -- bytes
    start_mle_total_memory_in_use         integer           not null, -- bytes
    start_java_session_heap_used_size_max integer           not null, -- bytes
    -- columns populated after execution of stmt (update)
    end_time                              timestamp         null,
    end_db_time                           integer           null,
    end_session_uga_memory_max            integer           null,
    end_session_pga_memory_max            integer           null,
    end_mle_total_memory_in_use           integer           null,
    end_java_session_heap_used_size_max   integer           null,
    -- populated only after an exception (update)
    error                                 clob              null
);
