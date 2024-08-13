create or replace package validator_api is
   function is_email(
      in_email in varchar2
   ) return boolean deterministic;
end validator_api;
/
