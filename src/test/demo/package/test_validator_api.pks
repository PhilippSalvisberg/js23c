create or replace package test_validator_api is
   --%suite
   --%suitepath(all)

   --%test
   procedure is_email_default_settings;

   --%test
   procedure is_email_custom_settings;

   --%test
   procedure is_email_djs_default_settings;

   --%test
   procedure is_email_djs_custom_settings;
end test_validator_api;
/