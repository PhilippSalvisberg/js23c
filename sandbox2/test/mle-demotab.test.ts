import { beforeAll, afterAll, describe, it, expect, beforeEach } from "vitest";
import { createSessions, closeSessions, otheruserSession, demotabSession, demotabConfig } from "./dbconfig";
import oracledb from "oracledb";
import { exec } from "child_process";
import util from "node:util";

describe("MLE JavaScript module within the database", () => {
    const timeout = 15000;

    async function userTables(): Promise<oracledb.Result<unknown>> {
        return await otheruserSession.execute(`
            with
               function num_rows(in_table_name in varchar2) return integer is
                  l_rows integer;
               begin
                  execute immediate 'select count(*) from ' || in_table_name 
                     into l_rows;
                  return l_rows;
               end;
            select table_name, num_rows(table_name) as num_rows
              from user_tables
             order by table_name
        `);
    }

    beforeAll(async () => {
        await createSessions();
        const execAsync = util.promisify(exec);
        await execAsync(
            `sql -S ${demotabConfig.user}/${demotabConfig.password}@${demotabConfig.connectString} @deploy.sql`
        );
    }, timeout);

    beforeEach(async () => {
        await otheruserSession.execute(`
            begin
               for r in (select table_name from user_tables) loop
                  execute immediate 'drop table ' 
                     || r.table_name
                     || ' cascade constraints purge';
               end loop;
            end;
        `);
    });

    describe("deployment", () => {
        it("should have valid database objects in demotab user", async () => {
            const mods = await demotabSession.execute(`
                select object_type, object_name, status 
                  from user_objects 
                 order by object_type, object_name
            `);
            expect(mods.rows).toEqual([
                ["MLE ENVIRONMENT", "DEMOTAB_ENV", "VALID"],
                ["MLE MODULE", "DEMOTAB_MOD", "VALID"],
                ["MLE MODULE", "SQL_ASSERT_MOD", "VALID"],
                ["PACKAGE", "DEMO", "VALID"]
            ]);
        });
    });

    describe("run MLE module from otheruser", () => {
        it("should create 'dept' and 'emp' without parameters", async () => {
            await otheruserSession.execute("begin demo.create_tabs; end;");
            expect((await userTables()).rows).toEqual([
                ["DEPT", 4],
                ["EMP", 14]
            ]);
        });
        it("should create 'd' and 'emp' with first parameter only", async () => {
            await otheruserSession.execute("begin demo.create_tabs('d'); end;");
            expect((await userTables()).rows).toEqual([
                ["D", 4],
                ["EMP", 14]
            ]);
        });
        it("should create 'd' and 'e' with both parameters", async () => {
            await otheruserSession.execute("begin demo.create_tabs('d', 'e'); end;");
            expect((await userTables()).rows).toEqual([
                ["D", 4],
                ["E", 14]
            ]);
        });
    });

    afterAll(async () => {
        await closeSessions();
    });
});
