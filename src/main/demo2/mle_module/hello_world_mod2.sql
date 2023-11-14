create or replace mle module hello_world_mod language javascript as
export function greet(firstName = "World", lastName = " ") {
   return `Hello ${firstName} ${lastName}`.trim();
}
/
