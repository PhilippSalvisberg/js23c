create or replace package body test_validator_api is
   procedure is_email_default_settings is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      -- convert boolean to varchar2 since utPLSQL does not support boolean yet
      open c_actual for
         with
            tests (email) as (values
               ('philipp@salvis.com'),
               ('philipp@salvis_blog.com'),
               ('philipp@salvis'),
               ('Philipp Salvisberg <philipp@salvis.com>')
            )
         select email, to_char(validator_api.is_email(email)) as is_valid
           from tests;
      open c_expected for
         with
            expected (email, is_valid) as (values
               ('philipp@salvis.com', 'TRUE'),
               ('philipp@salvis_blog.com', 'FALSE'),
               ('philipp@salvis', 'FALSE'),
               ('Philipp Salvisberg <philipp@salvis.com>', 'FALSE')
            )
         select email, is_valid 
           from expected;

      -- assert
      ut.expect(c_actual).to_equal(c_expected).join_by('EMAIL');
   end is_email_default_settings;

   procedure is_email_custom_settings is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      -- convert boolean to varchar2 since utPLSQL does not support boolean yet
      open c_actual for
         with
            tests (email) as (values
               ('philipp@salvis.com'),
               ('philipp@salvis_blog.com'),
               ('philipp@salvis'),
               ('Philipp Salvisberg <philipp@salvis.com>')
            )
         select email, 
                to_char(
                   validator_api.is_email(
                      in_email   => email,
                      in_options => json(
                                       json_object(
                                          'allow_display_name' value true,
                                          'allow_underscores' value true,
                                          'require_tld' value false
                                       )
                                    )
                   )
                ) as is_valid
           from tests;
      open c_expected for
         with
            expected (email, is_valid) as (values
               ('philipp@salvis.com', 'TRUE'),
               ('philipp@salvis_blog.com', 'TRUE'),
               ('philipp@salvis', 'TRUE'),
               ('Philipp Salvisberg <philipp@salvis.com>', 'TRUE')
            )
         select email, is_valid 
           from expected;

      -- assert
      ut.expect(c_actual).to_equal(c_expected).join_by('EMAIL');
   end is_email_custom_settings;

   procedure is_email_mle_default_settings is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      -- convert boolean to varchar2 since utPLSQL does not support boolean yet
      open c_actual for
         with
            tests (email) as (values
               ('philipp@salvis.com'),
               ('philipp@salvis_blog.com'),
               ('philipp@salvis'),
               ('Philipp Salvisberg <philipp@salvis.com>')
            )
         select email, to_char(validator_api.is_email_mle(email)) as is_valid
           from tests;
      open c_expected for
         with
            expected (email, is_valid) as (values
               ('philipp@salvis.com', 'TRUE'),
               ('philipp@salvis_blog.com', 'FALSE'),
               ('philipp@salvis', 'FALSE'),
               ('Philipp Salvisberg <philipp@salvis.com>', 'FALSE')
            )
         select email, is_valid 
           from expected;

      -- assert
      ut.expect(c_actual).to_equal(c_expected).join_by('EMAIL');
   end is_email_mle_default_settings;

   procedure is_email_mle_custom_settings is
      c_actual   sys_refcursor;
      c_expected sys_refcursor;
   begin
      -- act
      -- convert boolean to varchar2 since utPLSQL does not support boolean yet
      open c_actual for
         with
            tests (email) as (values
               ('philipp@salvis.com'),
               ('philipp@salvis_blog.com'),
               ('philipp@salvis'),
               ('Philipp Salvisberg <philipp@salvis.com>')
            )
         select email, 
                to_char(
                   validator_api.is_email_mle(
                      in_email   => email,
                      in_options => json(
                                       json_object(
                                          'allow_display_name' value true,
                                          'allow_underscores' value true,
                                          'require_tld' value false
                                       )
                                    )
                   )
                ) as is_valid
           from tests;
      open c_expected for
         with
            expected (email, is_valid) as (values
               ('philipp@salvis.com', 'TRUE'),
               ('philipp@salvis_blog.com', 'TRUE'),
               ('philipp@salvis', 'TRUE'),
               ('Philipp Salvisberg <philipp@salvis.com>', 'TRUE')
            )
         select email, is_valid 
           from expected;

      -- assert
      ut.expect(c_actual).to_equal(c_expected).join_by('EMAIL');
   end is_email_mle_custom_settings;
end test_validator_api;
/
