# JavaScript Tests in the Oracle Database 23c

## Introduction 

This repository contains the example used in the presentation [PL/SQL vs. JavaScript in the Oracle Database 23c,](https://www.salvis.com/blog/talks/).

The examples require an [Oracle Database 23.3 Free](https://www.oracle.com/database/technologies/free-downloads.html) or newer with an with an installed [utPLSQL](https://github.com/utPLSQL/utPLSQL) framework v3.1.13 or newer.

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

The installation uses the `script` command and therefore requires a recent version of SQLcl or SQL Developer. It will not work with SQL*Plus or another client.

1. Connect as `sys` and run [`@install.sql`](install.sql).

## Uninstallation

Connect as `sys` and run `drop user demo cascade;`.

## Experiments

The experiments ran on a [Synology DS923+](https://www.synology.com/en-global/products/DS923+#specs) with 64 GB RAM and a [AMD Ryzen R1600](https://www.cpubenchmark.net/cpu.php?cpu=AMD+Ryzen+Embedded+R1600) dual-core CPU and a volume based on two [WD Red SA 500 4TB](https://www.westerndigital.com/products/internal-drives/wd-red-sata-2-5-ssd?sku=WDS400T1R0A) SSDs. 

The Oracle Database 23c Free ran in a Docker container based on the image `container-registry.oracle.com/database/free:23.3.0.0`. A mem_limit of 4G was configured for this container.
