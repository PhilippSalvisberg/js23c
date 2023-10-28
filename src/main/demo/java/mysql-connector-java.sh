# Requires a full Oracle client or must run on the the database server.
# JAR must be downloaded first.
# Script is not called by installation process.
loadjava -thin \
   -user myuser/mypassword@localhost:1521:orcl \
   -genmissing \
   -resolve \
   -resolver "((* MYUSER) (* PUBLIC) (* -))" \
   -verbose \
   -stdout \
   mysql-connector-java-5.0.8-bin.jar
