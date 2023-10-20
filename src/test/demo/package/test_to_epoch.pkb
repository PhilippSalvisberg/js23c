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
      l_actual := demo.to_epoch_plsql(timestamp '2023-07-05 12:00:00');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end to_epoch_plsql;

   procedure to_epoch_java is
      l_actual   integer := 0;
      l_expected integer := 1688551201000; -- 2023-07:05 10:00:01 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo.to_epoch_java(timestamp '2023-07-05 12:00:01');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_djs is
      l_actual   integer := 0;
      l_expected integer := 1688551202000; -- 2023-07:05 10:00:02 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo.to_epoch_djs(timestamp '2023-07-05 12:00:02');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;

   procedure to_epoch_js is
      l_actual   integer := 0;
      l_expected integer := 1688551203000; -- 2023-07:05 10:00:03 UTC, https://www.epochconverter.com/
   begin
      -- act
      l_actual := demo.to_epoch_js(timestamp '2023-07-05 12:00:03');
      
      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end;
end test_to_epoch;
/