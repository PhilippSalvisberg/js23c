-- Requires SQLcl or SQL Developer (does not work in SQL*Plus or other clients).
-- Script is not called by the installation process.
set define off
script
const url = new java.net.URL("https://esm.run/jimp@0.22.10/browser/lib/jimp.js");
const content = new java.lang.String(url.openStream().readAllBytes(), 
                java.nio.charset.StandardCharsets.UTF_8);
const script = 'create or replace mle module jimp_mod '
                    + 'language javascript as ' + '\n' 
                    + content + "\n"
                    + '/' + "\n";
sqlcl.setStmt(script);
sqlcl.run();
/
