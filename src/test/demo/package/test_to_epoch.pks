create or replace package test_to_epoch is
   --%suite
   --%suitepath(all)
   
   --%beforeall
   procedure setup;

   --%afterall
   procedure teardown;

   --%test
   procedure to_epoch_plsql;

   --%test
   procedure to_epoch_java;

   --%test
   procedure to_epoch_mle;

   --%test
   procedure to_epoch_js;
end test_to_epoch;
/