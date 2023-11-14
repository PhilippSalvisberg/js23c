create or replace function greet(
   in_first_name varchar2 default 'World',
   in_last_name  varchar2 default ' '
) return varchar2 as mle module hello_world_mod signature 'greet(string, string)';
/

/* Causes the following error:

LINE/COL  ERROR
--------- -------------------------------------------------------------
0/0       PL/SQL: Compilation unit analysis terminated
1/10      PLS-00255: CALL Specification parameters cannot have default values
Errors: check compiler log
*/
