#!/bin/bash

con14="dbdumper"
NETW='dockercompose_dockercompose-frontend'
SVDB='dockercompose-mydb-1'
path14="/opt/docker/dockercompose/backup"

# Stop mydb container
docker compose -f docker-compose.yml stop mydb

# Rename the old dump is exists
if [ -f $path14/mydb.sql ]; then
    ctime=$(date +"%y%m%d_%H%M")
    mv $path14/mydb.sql $path14/mydb_$ctime.sql
    echo "The new file $path14/mydb_$ctime.sql created"
else
    sudo mkdir -p $path14
    sudo chown -R debian:debian $path14
    sudo chmod -R 777 $path14
    echo "The new directory $path14 created"
fi

# Run a net mariadb container in the same internal docker network
docker run -d --name $con14 --network $NETW -v $path14:/backup -v dockercompose_mydbdata:/var/lib/mysql dockercompose-mydb:latest

# Make a dump of the data on the 'dockercompose_mydbdata' volume
source .env && docker exec -i $con14 bash -c "mysqldump -u root -p$MARIADB_ROOT_PASSWORD --column-statistics=0 mydb > /backup/mydb.sql"

#### If you need to make a dump without stopping the main database
#### source .env && docker run --rm --name dbdumper --network dockercompose_dockercompose-frontend -v /opt/docker/dockercompose/task-13:/backup dockercompose-mydb:latest sh -c "mysqldump -h mydb -u root -p$MARIADB_ROOT_PASSWORD --column-statistics=0 --lock-tables=FALSE --databases mydb > /backup/mydb.sql"

# Check the exit status of the mysqldump command
# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  echo "Database 'mydb' dumped successfully to $path14/mydb.sql"
else
  echo "Error dumping database 'mydb'"
fi

# Cleanup
echo "What else (stop/remove/quit)?"
input=""
while [[ -z "$input" ]]; do
    read -n 1 -r -p "Enter 's/r/q': " input
    case $input in
    s | S)
        echo ""
        docker stop $con14
        echo ""
        break
        ;;
    r | R)
        echo ""
        docker stop $con14
        docker rm $con14
        echo ""
        break
        ;;
    q | Q)
        echo ""
        echo "The container $con14 wasn't stopped nor removed"
        echo ""
        break
        ;;
    *)
        echo "Invalid input"
        input=""
        ;;
    esac
done

# Run mydb container
docker compose -f docker-compose.yml start mydb
echo ""