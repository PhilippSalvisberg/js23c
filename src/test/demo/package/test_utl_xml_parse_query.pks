create or replace package test_utl_xml_parse_query is
   --%suite
   --%suitepath(all)

   --%test
   procedure simple_query;

   --%test
   procedure join_query;

end test_utl_xml_parse_query;
/