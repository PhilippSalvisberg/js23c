-- Privileges required for mysql-connector-java-5.0.8-bin.jar.
-- Script is not called by the installation process.
declare
   co_user constant all_users.username%type := 'MYUSER';
begin
   dbms_java.grant_permission(co_user,
      'SYS:java.net.SocketPermission', '*:1024-65535', 'connect, resolve');
   dbms_java.grant_permission(co_user, 
      'SYS:java.io.FilePermission', '/tmp', 'read, write');
   dbms_java.grant_permission(co_user, 
      'SYS:java.lang.RuntimePermission', 'getClassLoader', '');
   dbms_java.grant_permission(co_user, 
      'SYS:java.lang.RuntimePermission', 'setContextClassLoader', '');
end;
/
