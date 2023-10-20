create or replace view utl_xml_parse_query_examples as
with
   function parse_query(
      in_parse_user in varchar2,
      in_query      in clob
   ) return sys.xmltype is
      l_clob clob;
      l_xml  sys.xmltype;
   begin
      if in_query is not null and sys.dbms_lob.getlength(in_query) > 0 then
         sys.dbms_lob.createtemporary(l_clob, true);
         utl_xml_parse_query(sys_context('userenv', 'current_schemaid'), in_parse_user, in_query, l_clob);
         if sys.dbms_lob.getlength(l_clob) > 0 then
            l_xml := sys.xmltype.createxml(l_clob);
         end if;
         sys.dbms_lob.freetemporary(l_clob);
      end if;
      return l_xml;
   end;
   examples (id, statement) as (values
      (1, 'select ename, sal from emp where sal >= 3000 order by sal desc'),
      (2, q'[insert into dept(deptno, dname, loc) values (50, 'Oracle Labs', 'Zurich')]'),
      (3, 'update emp set sal = sal * 2 where sal < 3000'),
      (4, 'delete from dept where deptno = 50')
   )
select id, statement, parse_query(sys_context('userenv', 'current_schema'), statement) as parse_tree
  from examples;
/
