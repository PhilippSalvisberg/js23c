-- Requires SQLcl or SQL Developer (does not work in SQL*Plus or other clients).
set define off
script
var url = new java.net.URL("https://esm.run/sql-template-tag@5.1.0");
var content = new java.lang.String(url.openStream().readAllBytes(), 
                java.nio.charset.StandardCharsets.UTF_8);
var script = 'set scan off ' + '\n' 
                + 'create or replace mle module sql_template_tag_mod '
                + 'language javascript as ' + '\n' 
                + content + "\n"
                + '/' + "\n";
sqlcl.setStmt(script);
sqlcl.run();
/
