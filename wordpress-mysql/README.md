# 2024-06-18    09:48
=====================

To run this app you need VirtualBox with setted up Debian11 virtual machine 'docker-lab' (or a sort of).
```bash
./vmstart
cd /home/debian/final-subtask1/
ls -alg
./1-script.sh
cd /opt/docker/final-task1/
docker build
docker compose up -d
```

If all was setted up in correct way, you will have a 2-containers infrastructure using orchestration tool (Docker-compose).
+ *Application*: Wordpress running along with database.
+ *Container 1*: web-server with Wordpress running on it
    - Use the Dockerfile in the folder for building your image;
    - Use wordpress:latest for your builts
    - Wordpress apllication should be available at 8080 port. For example, http://VM_IP_ADDRESS:8080 should show Wordpress start page where you should choose the language
    - Name of the container: my-awesome-wordpress;
    - Use custom bridge network called my-awesome-network;
    - To configure Wordpress use wp-config.php file. Pass it into the container /var/www/html directory;
    - Check the default values in wp-config.php and adjust them if required:
          a) DB_NAME: wordpress -- defines the name of a DB for Wordpress;
          b) DB_USER: wordpress -- defines the the name of DB user for Wordpress;
          c) DB_PASSWORD: wordpress -- defines a password for the DB;
          d) DB_HOST: localhost:3306 (Define your DB endpoint. Format is like here: db_endpoint:db_port; e.g. localhost:3306 -- a default value provided by Wordpress. Insert yours instead) -- defines an endpoint the DB is accessible through;
    - wp-config.php file is owned by root initially. Its owner and owner's group should be www-data inside the container for Wordpress to work properly - bear this in mind while building your image;
    - Container should always restart in case of failures but not when stopped explicitly;
    *Note*: Configuration should persist even when the container has restarted!
+ *Container 2*: DB container running a MySQL database with some custom configuration:
    - Name of the container: my-awesome-database;
    - This container should always start first -- don't forget to build a dependency between the DB and Wordpress;
    - Use mysql:5.7 image;
    - Use environment variables to configure access. See the official image documentation for more information regarding configuration;
    - Make sure your awesome Wordpress and Database can communicate to each other using container names;
    - Container should always restart in case of failures but not when stopped explicitly;
    *Note*: DB files should persist even when the container has restarted!