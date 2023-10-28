create or replace package validator_api is
   function is_email(
      in_email in varchar2
   ) return boolean as mle module validator_mod signature 'default.isEmail(string)';

   function is_email(
      in_email   in varchar2,
      in_options in json
   ) return boolean as mle module validator_mod signature 'default.isEmail(string, any)';

   function is_email_djs(
      in_email   in varchar2,
      in_options in json default null
   ) return boolean;
end validator_api;
/
