create or replace package hello_world is
   function greet
      return varchar2 as mle module hello_world_mod signature 'greet()';
   function greet(
      in_first_name in varchar2
   ) return varchar2 as mle module hello_world_mod signature 'greet(string)';
   function greet(
      in_first_name in varchar2,
      in_last_name  in varchar2
   ) return varchar2 as mle module hello_world_mod signature 'greet(string, string)';
end;
/

column greet_p0 format a20
column greet_p1 format a20
column greet_p2 format a20

select hello_world.greet() as greet_p0, 
       hello_world.greet('John') as greet_p1, 
       hello_world.greet('John', 'Doe') as greet_p2;

/* Result is
GREET_P0             GREET_P1             GREET_P2            
-------------------- -------------------- --------------------
Hello World          Hello John           Hello John Doe      
*/
