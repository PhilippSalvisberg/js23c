import oracledb from "oracledb";

export let sysSession: oracledb.Connection;
export let demotabSession: oracledb.Connection;
export let otheruserSession: oracledb.Connection;

const connectString = "192.168.1.8:51007/freepdb1";

const sysConfig: oracledb.ConnectionAttributes = {
    user: "sys",
    password: "oracle",
    connectString: connectString,
    privilege: oracledb.SYSDBA
};

export const demotabConfig: oracledb.ConnectionAttributes = {
    user: "demotab",
    password: "demotab",
    connectString: connectString
};

export const otheruserConfig: oracledb.ConnectionAttributes = {
    user: "otheruser",
    password: "otheruser",
    connectString: connectString
};

export async function createSessions(): Promise<void> {
    sysSession = await oracledb.getConnection(sysConfig);
    await createUser(demotabConfig);
    await createUser(otheruserConfig);
    await sysSession.execute("grant create public synonym to demotab");
    await sysSession.execute("grant execute on javascript to public");
    demotabSession = await oracledb.getConnection(demotabConfig);
    otheruserSession = await oracledb.getConnection(otheruserConfig);
}

async function createUser(config: oracledb.ConnectionAttributes): Promise<void> {
    await sysSession.execute(`drop user if exists ${config.user} cascade`);
    await sysSession.execute(`
        create user ${config.user} identified by ${config.password}
           default tablespace users
           temporary tablespace temp
           quota 1m on users
    `);
    await sysSession.execute(`grant db_developer_role to ${config.user}`);
}

export async function closeSessions(): Promise<void> {
    await sysSession?.close();
    await demotabSession?.close();
    await otheruserSession?.close();
}
