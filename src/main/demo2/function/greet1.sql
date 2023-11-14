create or replace function greet(
   in_first_name varchar2,
   in_last_name  varchar2
) return varchar2 as mle module hello_world_mod signature 'greet(string, string)';
/

column greet format a20

select greet('John', 'Doe') as greet;

/* Result is
GREET               
--------------------
Hello John Doe
*/