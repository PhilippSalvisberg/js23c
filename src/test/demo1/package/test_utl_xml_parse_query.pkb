create or replace package body test_utl_xml_parse_query is
   procedure simple_query is
      l_actual   clob;
      l_expected clob := 
'<QUERY>
  <SELECT>
    <SELECT_LIST>
      <SELECT_LIST_ITEM>
        <LITERAL>*</LITERAL>
      </SELECT_LIST_ITEM>
    </SELECT_LIST>
  </SELECT>
  <FROM>
    <FROM_ITEM>
      <TABLE>EMP</TABLE>
    </FROM_ITEM>
  </FROM>
</QUERY>
';
   begin
      -- arrage
      sys.dbms_lob.createtemporary(l_actual, true);
      
      -- act 
      -- Dynamic SQL as workaround to avoid PLS-00306: wrong number or types of arguments.
      -- Works as plsql_declaration, which is not supported statically in PL/SQL and
      -- also when utl_xml_parse_query is defined in the package body.
      execute immediate
         q'[
            begin
               utl_xml_parse_query(
                  in_current_userid => sys_context('userenv', 'current_schemaid'),
                  in_schema_name    => sys_context('userenv', 'current_schema'),
                  in_query          => 'select * from emp',
                  io_result         => :actual
               );
            end;
         ]'
         using in out l_actual;

      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end simple_query;

   procedure join_query is
      l_actual   clob;
      l_expected clob := 
'<QUERY>
  <SELECT>
    <SELECT_LIST>
      <SELECT_LIST_ITEM>
        <COLUMN_REF>
          <TABLE_ALIAS>D</TABLE_ALIAS>
          <COLUMN>DEPTNO</COLUMN>
        </COLUMN_REF>
      </SELECT_LIST_ITEM>
      <SELECT_LIST_ITEM>
        <COLUMN_REF>
          <TABLE_ALIAS>D</TABLE_ALIAS>
          <COLUMN>DNAME</COLUMN>
        </COLUMN_REF>
      </SELECT_LIST_ITEM>
      <SELECT_LIST_ITEM>
        <COALESCE>
          <SUM>
            <COLUMN_REF>
              <TABLE_ALIAS>E</TABLE_ALIAS>
              <COLUMN>SAL</COLUMN>
            </COLUMN_REF>
          </SUM>
          <LITERAL>0</LITERAL>
        </COALESCE>
        <COLUMN_ALIAS>SUM_SAL</COLUMN_ALIAS>
      </SELECT_LIST_ITEM>
      <SELECT_LIST_ITEM>
        <COALESCE>
          <COUNT>
            <COLUMN_REF>
              <TABLE_ALIAS>E</TABLE_ALIAS>
              <COLUMN>EMPNO</COLUMN>
            </COLUMN_REF>
          </COUNT>
          <LITERAL>0</LITERAL>
        </COALESCE>
        <COLUMN_ALIAS>NUM_EMPS</COLUMN_ALIAS>
      </SELECT_LIST_ITEM>
      <SELECT_LIST_ITEM>
        <COALESCE>
          <ROUND>
            <AVG>
              <COLUMN_REF>
                <TABLE_ALIAS>E</TABLE_ALIAS>
                <COLUMN>SAL</COLUMN>
              </COLUMN_REF>
            </AVG>
            <LITERAL>2</LITERAL>
          </ROUND>
          <LITERAL>0</LITERAL>
        </COALESCE>
        <COLUMN_ALIAS>AVG_SAL</COLUMN_ALIAS>
      </SELECT_LIST_ITEM>
    </SELECT_LIST>
  </SELECT>
  <FROM>
    <FROM_ITEM>
      <JOIN>
        <INNER/>
        <JOIN_TABLE_1>
          <TABLE>DEPT</TABLE>
          <TABLE_ALIAS>D</TABLE_ALIAS>
        </JOIN_TABLE_1>
        <JOIN_TABLE_2>
          <TABLE>EMP</TABLE>
          <TABLE_ALIAS>E</TABLE_ALIAS>
        </JOIN_TABLE_2>
        <ON>
          <EQ>
            <COLUMN_REF>
              <TABLE>EMP</TABLE>
              <TABLE_ALIAS>E</TABLE_ALIAS>
              <COLUMN>DEPTNO</COLUMN>
            </COLUMN_REF>
            <COLUMN_REF>
              <TABLE>DEPT</TABLE>
              <TABLE_ALIAS>D</TABLE_ALIAS>
              <COLUMN>DEPTNO</COLUMN>
            </COLUMN_REF>
          </EQ>
        </ON>
      </JOIN>
    </FROM_ITEM>
  </FROM>
  <WHERE>
    <IS_NOT_NULL>
      <COLUMN_REF>
        <TABLE_ALIAS>D</TABLE_ALIAS>
        <COLUMN>LOC</COLUMN>
      </COLUMN_REF>
    </IS_NOT_NULL>
  </WHERE>
  <GROUP_BY>
    <EXPRESSION_LIST>
      <EXPRESSION_LIST_ITEM>
        <COLUMN_REF>
          <TABLE_ALIAS>D</TABLE_ALIAS>
          <COLUMN>DEPTNO</COLUMN>
        </COLUMN_REF>
      </EXPRESSION_LIST_ITEM>
      <EXPRESSION_LIST_ITEM>
        <COLUMN_REF>
          <TABLE_ALIAS>D</TABLE_ALIAS>
          <COLUMN>DNAME</COLUMN>
        </COLUMN_REF>
      </EXPRESSION_LIST_ITEM>
    </EXPRESSION_LIST>
  </GROUP_BY>
</QUERY>
';
   begin
      -- arrage
      sys.dbms_lob.createtemporary(l_actual, true);
      
      -- act 
      -- Dynamic SQL as workaround to avoid PLS-00306: wrong number or types of arguments.
      -- Works as plsql_declaration, which is not supported statically in PL/SQL and
      -- also when utl_xml_parse_query is defined in the package body.
      execute immediate
         q'[
            begin
               utl_xml_parse_query(
                  in_current_userid => sys_context('userenv', 'current_schemaid'),
                  in_schema_name    => sys_context('userenv', 'current_schema'),
                  in_query          => q'~
                                          select d.deptno,
                                                 d.dname,
                                                 coalesce(sum(e.sal), 0) as sum_sal,
                                                 coalesce(count(e.empno), 0) as num_emps,
                                                 coalesce(round(avg(e.sal), 2), 0) as avg_sal
                                            from dept d
                                            left join emp e
                                              on e.deptno = d.deptno
                                           where d.loc is not null
                                           group by d.deptno, d.dname
                                       ~',
                  io_result         => :actual
               );
            end;
         ]'
         using in out l_actual;

      -- assert
      ut.expect(l_actual).to_equal(l_expected);
   end join_query;
end test_utl_xml_parse_query;
/