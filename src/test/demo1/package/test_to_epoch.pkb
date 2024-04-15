create or replace package body test_to_epoch is
   procedure setup is
   begin
      -- eliminate issues with daylight saving time, simulate Europe/Zurich
      execute immediate q'[alter session set time_zone='+02:00']';
   end setup;

   procedure teardown is
   begin
      execute immediate q'[alter session set time_zone=local]';
   end teardown;

   procedure to_epoch_plsql is
      l_actual   integer := 0;
      l_expected integer := 1688551200000; -- 2023-07:05 10:00:00 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo1.to_epoch_plsql(timestamp '2023-07-05 12:00:00');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end to_epoch_plsql;

   procedure to_epoch_java is
      l_actual   integer := 0;
      l_expected integer := 1688551201000; -- 2023-07:05 10:00:01 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo1.to_epoch_java(timestamp '2023-07-05 12:00:01');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_djs is
      l_actual   integer := 0;
      l_expected integer := 1688551202000; -- 2023-07:05 10:00:02 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo1.to_epoch_djs(timestamp '2023-07-05 12:00:02');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_djs2 is
      l_ctx      dbms_mle.context_handle_t;
      l_actual   integer := 0;
      l_expected integer := 1688551204000; -- 2023-07:05 10:00:04 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_ctx    := dbms_mle.create_context();
      l_actual := demo1.to_epoch_djs2(
                     in_ctx => l_ctx,
                     in_ts  => timestamp '2023-07-05 12:00:04'
                  );
      dbms_mle.drop_context(l_ctx);
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_js is
      l_actual   integer := 0;
      l_expected integer := 1688551203000; -- 2023-07:05 10:00:03 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo1.to_epoch_js(timestamp '2023-07-05 12:00:03');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_js2 is
      l_actual   integer := 0;
      l_expected integer := 1688551203000; -- 2023-07:05 10:00:03 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo1.to_epoch_js2(timestamp '2023-07-05 12:00:03');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;
end test_to_epoch;
/
