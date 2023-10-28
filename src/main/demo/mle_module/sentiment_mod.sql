-- Requires SQLcl or SQL Developer (does not work in SQL*Plus or other clients).
-- Script is not called by the installation process.
set define off
script
var url = new java.net.URL("https://esm.run/sentiment");
var content = new java.lang.String(url.openStream().readAllBytes(), 
                java.nio.charset.StandardCharsets.UTF_8);
var script = 'set scan off ' + '\n' 
                + 'create or replace mle module sentiment_mod '
                + 'language javascript as ' + '\n' 
                + content + "\n"
                + '/' + "\n";
sqlcl.setStmt(script);
sqlcl.run();
/