# JavaScript Tests in the Oracle Database 23ai

## Introduction

This repository contains the example used in the presentation [PL/SQL vs. JavaScript in the Oracle Database](https://www.salvis.com/blog/talks/).

The examples require an [Oracle Database 23.5 Free](https://www.oracle.com/database/technologies/free-downloads.html) or newer with an installed [utPLSQL](https://github.com/utPLSQL/utPLSQL) framework v3.1.13 or newer.

## Database Configuration

The available resources in a Oracle Database 23.3 are limited. On the database server I started `sqlplus / as sysdba` and ran the following

```sql
-- 1536M this is the default (75% of 2G max.)
alter system set sga_target=1536M scope=spfile;
-- 512M is the default (25% of 2G max.)
alter system set pga_aggregate_target=512M scope=spfile;

-- SGA subarea settings
-- 0 is the default
alter system set java_pool_size=32M scope=spfile;

-- restart the database
shutdown immediate;
startup;
```

## Installation

The installation uses the `script` command and therefore requires a recent version of SQLcl or SQL Developer. It will not work with SQL*Plus or another client. Furthermore SQLcl must use JRE with an JavaScript engine, since SQLcl does not come with a JavaScript engine. This is either a JDK 11 or a GraalVM JDK 17 for which JavaScript is installed via `gu install js`. Please note that `gu` was decommissioned in the latest GraalVM JDK.

Connect as `sys` and run [`@install.sql`](install.sql).

## Uninstallation

Connect as `sys` and run `drop user demo1 cascade;`.

## Experiments

### `...result.csv`

These experiments ran on a [Synology DS923+](https://www.synology.com/en-global/products/DS923+#specs) with 64 GB RAM and a [AMD Ryzen R1600](https://browser.geekbench.com/v6/cpu/1994870) dual-core CPU and a volume based on two [WD Red SA 500 4TB](https://www.westerndigital.com/products/internal-drives/wd-red-sata-2-5-ssd?sku=WDS400T1R0A) SSDs.

The Oracle Database 23ai Free ran in a Docker container based on the image `gvenzl/oracle-free:23.5-full-faststart`. A mem_limit of 4G was configured for this container.


## Sandbox1

Small node.js project to run the same or similar JS code from mocha tests, which are more "demos". This allows me to use the autocomplete features of the IDE and the debugger for a better understanding of the codebase.

## Sandbox2

Another node.js project for a MLE module written in TypeScript. The idea is to provide a public stored procedure in the database that creates and populates the well-known tables `dept` and `emp` in the current schema.

## [jsdelivr.com](https://www.jsdelivr.com/)

This CDN has the capability to provide an ESM for packages hosted on NPM. The goal is to simplify the inclution in HTML pages. The bundling process detects modules that are accessing the network or the filesystem. In such cases no ESM is produced. Instead a error message is returned. Here are some examples:

- [node-oracledb v6.2.0](https://esm.run/oracledb@6.2.0)

    ```
    /**
    * Failed to bundle using Rollup v2.79.1: the file imports a not supported node.js built-in module "net".
    * If you believe this to be an issue with jsDelivr, and not with the package itself, please open an issue at https://github.com/jsdelivr/jsdelivr
    */

    throw new Error('Failed to bundle using Rollup v2.79.1: the file imports a not supported node.js built-in module "net". If you believe this to be an issue with jsDelivr, and not with the package itself, please open an issue at https://github.com/jsdelivr/jsdelivr');
    ```

- [better-assert v1.0.2](https://esm.run/better-assert@1.0.2)

    ```
    /**
    * Failed to bundle using Rollup v2.79.1: the file imports a not supported node.js built-in module "fs".
    * If you believe this to be an issue with jsDelivr, and not with the package itself, please open an issue at https://github.com/jsdelivr/jsdelivr
    */

    throw new Error('Failed to bundle using Rollup v2.79.1: the file imports a not supported node.js built-in module "fs". If you believe this to be an issue with jsDelivr, and not with the package itself, please open an issue at https://github.com/jsdelivr/jsdelivr');
    ```

In [this comment](https://github.com/jsdelivr/jsdelivr/issues/18466#issuecomment-1435387331) a possible solution was suggested by adding `browser: { "fs/promises": false }` in the `package.json`.

In any case the issue has to be solved in the source project.
