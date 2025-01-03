# Readme for Sandbox3

Contains the example used in the demo of the presentation [How to Develop an MLE Module
with Oracle Database 23ai?](https://www.salvis.com/blog/wp-content/uploads/2024/11/salvisberg-how-to-develop-an-mle-module-with-oracle-datagbase-23ai-20241119.pdf) at DOAG 2024 Conference + Exhibition on 19 November 2024.

I ran the demo on my MacBook Pro with an Apple M1 Max chip and macOS 14.6.1. It should work on all platforms with small amendments.

## Prerequisites

### Oracle Database 23ai, version 23.5

I've installed the database locally using Docker. The image is just a copy of the one at https://container-registry.oracle.com/.
However, the registry only provides the latest versions, so I saved a copy of the image to Docker Hub.

It is important that you can connect via `sys/oracle@127.0.0.1:1522/freepdb1 as sysdba`. Otherwise you will need to edit `test/dbconfig.ts` accordingly.

```bash
# create container
docker run -d \
    --name 23.5 \
    -p 1522:1521 \
    -v 23.5-data:/opt/oracle/oradata \
    phsalvisberg/oracle-database-free:23.5-arm

# change password
docker exec -it 23.5 ./setPassword.sh oracle
```

### SQLcl with Java17 with JavaScript support

Install SQLcl. See https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/download/. I used version 24.3.1.311.1631.

SQLcl requires a JDK with Javascript enabled. Install GraalVM 17 and make it the default JDK.
See https://www.graalvm.org/downloads/ and https://www.oracle.com/java/technologies/downloads/#graalvmjava17.
I used Oracle GraalVM 17.0.12+8.1 via sdkman.

Then install `js` via `gu install js`.

`gu list` should give a result similar to:

```
ComponentId              Version             Component name                Stability                     Origin
---------------------------------------------------------------------------------------------------------------------------------
graalvm                  23.0.5              GraalVM Core                  Supported
icu4j                    23.0.5              ICU4J                         Supported                     gds.oracle.com
js                       23.0.5              Graal.js                      Supported                     gds.oracle.com
native-image             23.0.5              Native Image                  Early adopter
regex                    23.0.5              TRegex                        Supported                     gds.oracle.com
visualvm                 23.0.5              VisualVM EE                   Supported                     gds.oracle.com
```

Important are the lines with `js`, `icu4j` and `regex`.

## Install Node.js

See https://nodejs.org/en/download/package-manager. I used version 23.1.0.

## Build from scratch

### Clean non-versioned files

```bash
rm -r ./node_modules
rm -r ./coverage
rm -r ./esm
rm package-lock.json
```

### Install node modules

```bash
npm install
```

### Build and run tests

```
npm run build
```