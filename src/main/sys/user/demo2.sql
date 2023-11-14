-- Script is not called by the installation process.
drop user if exists demo2 cascade;

create user demo2 identified by demo2
  default tablespace users
  temporary tablespace temp
  quota 1m on users;

-- should cover the typical privileges required by a developer
grant db_developer_role to demo2;

-- ensure the grant is revoked, without trowing an error
-- privililege is granted in project of "sandbox2"
declare
   e_is_not_granted exception;
   pragma exception_init(e_is_not_granted, -1927);
begin
   execute immediate 'revoke execute on javascript from public';
exception
   when e_is_not_granted then
      null;
end;
/

-- after demonstrating error in hello_world.sql and hellow_world_mod1.sql grant manually:
-- see https://forums.oracle.com/ords/apexds/post/mle-ist-treated-as-second-class-citizen-db-developer-role-6186
-- and https://forums.oracle.com/ords/apexds/post/ora-00600-when-using-the-multi-row-values-constructor-inser-5558
/*
grant execute dynamic mle to demo2;
grant execute on javascript to demo2;
*/
