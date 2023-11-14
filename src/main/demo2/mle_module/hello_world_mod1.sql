create or replace mle module hello_world_mod language javascript as
export function greet() {
   return "Hello World";
}
/

/* Causes the following error (if user as only the db_developer_role):

ORA-04129: insufficient privileges to use MLE language JAVASCRIPT

Grants required:

grant execute on javascript to demo2;
*/
