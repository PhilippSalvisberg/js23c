create or replace package body validator_api is
   function is_email_internal(
      in_email   in varchar2,
      in_options in json
   ) return boolean deterministic as mle module validator_mod signature 'default.isEmail(string, any)';

   function is_email(
      in_email in varchar2
   ) return boolean deterministic is
   begin
      return is_email_internal(
                in_email   => in_email,
                in_options => json('
                                 {
                                    "allow_display_name": false,
                                    "allow_undescores": false,
                                    "require_display_name": false,
                                    "allow_utf8_local_part": true,
                                    "require_tld": true,
                                    "allow_ip_domain": false,
                                    "domain_specific_validation": false,
                                    "blacklisted_chars": "",
                                    "ignore_max_length": false,
                                    "host_blacklist": ["dubious.com"],
                                    "host_whitelist": []
                                 }
                              ')
             );
   end is_email;
end validator_api;
/
