-- Example of a PL/SQL wrapper for a procedure defined in a shared library.
-- It's a library provided by Oracle, however it works the same way for custom libraries.
-- This procedure was exposed in UTL_XML before version 18. With version 18 the
-- procedure is not accessible anymore, because it is protected by an accessible_by clause.
-- See https://www.salvis.com/blog/2018/04/30/accessible-pl-sql-programs-in-oracle-database-18c/ .
create or replace procedure utl_xml_parse_query(
   in_current_userid in            number,
   in_schema_name    in            varchar2,
   in_query          in            clob,
   io_result         in out nocopy clob
) is
   language c
   library sys.utl_xml_lib             -- static lib, part of the oracle binary
   name "kuxParseQuery"                -- name of the C function in the lib
   with context parameters (
      context,                         -- connection context, allows callbacks
      in_current_userid ocinumber,     -- content
      in_current_userid indicator,     -- null indicator 
      in_schema_name    ocistring,     -- content
      in_schema_name    indicator,     -- null indicator
      in_query          ociloblocator, -- content
      in_query          indicator,     -- null indicator   
      io_result         ociloblocator, -- content
      io_result         indicator      -- null indicator
   );
/
