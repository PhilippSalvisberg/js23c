create or replace function greet(
   in_first_name varchar2 default 'World',
   in_last_name  varchar2 default ' '
) return varchar2 is
   function internal_greet(
      in_first_name varchar2,
      in_last_name  varchar2
   ) return varchar2 as mle module hello_world_mod signature 'greet(string, string)';
begin
   return internal_greet(in_first_name, in_last_name);
end;
/

select greet('John', 'Doe');

/* causes the following error:

Error starting at line : 14 in command -
select greet('John', 'Doe')
Error at Command Line : 14 Column : 1
Error report -
SQL Error: ORA-00600: internal error code, arguments: [kgmexec21], [], [], [], [], [], [], [], [], [], [], []
ORA-06512: at "DEMO2.GREET", line 5
ORA-06512: at "DEMO2.GREET", line 10
ORA-06512: at line 1
00600. 00000 -  "internal error code, arguments: [%s], [%s], [%s], [%s], [%s], [%s], [%s], [%s], [%s], [%s], [%s], [%s]"
*Cause:    This is the generic internal error number for Oracle program
           exceptions. It indicates that a process has encountered a low-level,
           unexpected condition. The first argument is the internal message
           number. This argument and the database version number are critical in
           identifying the root cause and the potential impact to your system.

*/