create or replace package body test_validator_api is
   procedure is_email is
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
               ('Philipp Salvisberg <philipp@salvis.com>'),
               ('info@grisselbav.com'),
               ('esther.muster@example.com'),
               ('Esther Muster <esther.muster@example.com>'),
               ('ester.muster@dubious.com')
            )
         select email, to_char(validator_api.is_email(email)) as is_valid
           from tests;
      open c_expected for
         with
            expected (email, is_valid) as (values
               ('philipp@salvis.com', 'TRUE'),
               ('philipp@salvis_blog.com', 'FALSE'),
               ('philipp@salvis', 'FALSE'),
               ('Philipp Salvisberg <philipp@salvis.com>', 'FALSE'),
               ('info@grisselbav.com', 'TRUE'),
               ('esther.muster@example.com', 'TRUE'),
               ('Esther Muster <esther.muster@example.com>', 'FALSE'),
               ('ester.muster@dubious.com', 'FALSE')
            )
         select email, is_valid
           from expected;

      -- assert
      ut.expect(c_actual).to_equal(c_expected).join_by('EMAIL');
   end is_email;
end test_validator_api;
/
