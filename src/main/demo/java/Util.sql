-- Might cause a ORA-04031: out of shared memory in java pool.
-- In this case call "alter system set java_pool_size="32M" scope=spfile;" and restart the database
create or replace and compile java source named "Util" as
public class Util {
   public static long toEpoch(java.sql.Timestamp ts) {
	   return ts.getTime();
   }
}
/