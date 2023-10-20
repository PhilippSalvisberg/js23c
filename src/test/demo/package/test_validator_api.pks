create or replace package test_validator_api is
   --%suite
   --%suitepath(all)

   --%test
   procedure is_email_default_settings;

   --%test
   procedure is_email_custom_settings;

   --%test
   procedure is_email_mle_default_settings;

   --%test
   procedure is_email_mle_custom_settings;
end test_validator_api;
/