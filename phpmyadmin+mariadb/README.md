# 2024-06-15    16:56
=====================

To run the project you need Debian11 or a sort of.
In the project's directory you also have to have '.env' with 'MARIADB_ROOT_PASSWORD' declaration.

**Project plan**
1. Install Docker Compose
2. Define a simple service:
  - Define *frontend* service using image phpmyadmin:5.2.0-apache.
  - Use Dockerfile for building a custom image.
  - Add package *iputils-ping* into the image.
  - Start new defined service.
3. Expose phpmyadmin service port 80 to your host port 8080.
4. Define a custom network with name dockercompose-frontend and attach frontend to that network.
5. Define another simple service:
  - Define db service mydb. Use current LTS mariadb version image.
  - Use Dockerfile for building a custom image.
  - Add package iputils-ping into the image.
6. Check connection between mydb and phpmyadmin services with ping.
7. Attach mydb service to dockercompose-frontend network and check connection again.
8. Configure phpmyadmin:
  - Read related documentation: https://hub.docker.com/r/phpmyadmin/phpmyadmin/
  - Set mysql server host and mysql server port via environment variables for phpmyadmin, use documentation from previous step.
9. Define mysql data volume, attach it to mydb service. Mariadb should use it as data storage (by default it is /var/lib/mysql).
10. Set healthcheck:
  - Define mydb service healthcheck based on mysqladmin ping with interval 10s, timeout 15s, retries 5. See this page for more details.
  - Try to break mysql service inside container by change datafile permissions or/and rename mysql data files, or play with healthcheck command including defining incorrect command.
  - Check mysql container status/health.
  - Fix mysql service, make sure healthcheck is ok.
11. Define phpmyadmin service behavior start only if mydb service health is OK. Try to stop all services and start again. Make attention on container's start order.
12. Using phpmyadmin sql editor create database, table in that database and insert rows, using following commands:
  - create database mydb;
  - use mydb;
  - create table mytable ( id int AUTO_INCREMENT primary key, data text, datamodified timestamp default now());
  - insert into mytable(data) values("testdata01");
  - insert into mytable(data) values("testdata02");
  - insert into mytable(data) values("testdata03");
13. Make mysql dump using another mysql container, with attached volume for mysql backup.
14. Save the dump to /opt/docker/dockercompose/task-13/mydb.sql.


# N.B.: There is './task-13/mydb.sql' as an expamle of database's dump.