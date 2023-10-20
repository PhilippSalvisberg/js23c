create or replace package exec_api is
   procedure exec_stmt(
      in_scenario    in varchar2 default 'test',
      in_run         in integer  default 1,
      in_single_stmt in varchar2 default 'begin null; end;',
      in_no_of_calls in integer default 1
   );
end exec_api;
/