#!/bin/bash

NETW='dockercompose_dockercompose-frontend'
SRVS='dockercompose-frontend-1'
SVDB='dockercompose-mydb-1'
VOLUME='dockercompose_mydbdata'
DBIMG='dockercompose-mydb'
PHPIMG='dockercompose-frontend'
CURRENT_DATETIME=$(date +"%y%m%d-%H%M")
# shellcheck source=/dev/null
source '.env'

echo ">>>>> Step 1 - Build and Up. Current time: $CURRENT_DATETIME"
if docker images "$DBIMG:latest" | grep -q "$DBIMG"; then
    docker tag "$DBIMG:latest" "$DBIMG:$CURRENT_DATETIME"
    docker rmi $DBIMG:latest
fi
if docker images "$PHPIMG:latest" | grep -q "$PHPIMG"; then
    docker tag "$PHPIMG:latest" "$PHPIMG:$CURRENT_DATETIME"
    docker rmi $DBIMG:latest
fi

echo ""
echo "Run 'docker compose up':"
docker compose up -d

echo "Actual docker images list:"
docker images
echo "Wait for 10 seconds."
sleep 10
read -n 1 -s -r -p "Press a whitespace to continue >>>"
echo ""


echo ">>>>> Step 2 - The simple check"
curl http://localhost:8080
echo ""



echo ">>>>> Step 3 - Check if the network $NETW exists"
# Check if the network 'dockercompose-frontend' exists
if docker network inspect $NETW &> /dev/null; then
    echo "The $NETW network exists."
    echo ""


    echo ">>>>> Step 4 - Check if the $SRVS service is running"
    if docker ps | grep "$SRVS" &> /dev/null; then
        echo "The $SRVS service is running."

        # Check if there is a response from the 'frontend' service
        if curl -s http://localhost:8080 &> /dev/null; then
            echo "There is a response from the $SRVS service."
        else
            echo "There is no response from the $SRVS service."
            exit 1
        fi
    else
        echo "The $SRVS service is not running."
    fi


    echo ">>>>> Step 5 - Check if the $SVDB service is running"
    if docker ps | grep "$SVDB" &> /dev/null; then
        echo "The $SVDB service is running."
    else
        echo "The $SVDB service is not running."
        exit 2
    fi

else
    echo "The $NETW network does not exist."
    exit 3
fi

docker network ls



echo ">>>>> Step 6 - Ping connection between $SRVS and $SVDB services."
SVBD_IP=$(docker network inspect $NETW --format='{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' | grep $SVDB | cut -d' ' -f2 | cut -d'/' -f1)
SRVS_IP=$(docker network inspect $NETW --format='{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{"\n"}}{{end}}' | grep $SRVS | cut -d' ' -f2 | cut -d'/' -f1)

if docker exec -it $SRVS sh -c "ping -c 1 $SVBD_IP"; then
    echo "Ping from $SRVS to $SVDB is OK."
else
    echo "There is no ping from $SRVS to $SVDB."
    exit 4
fi
if docker exec -it $SVDB sh -c "ping -c 1 $SRVS_IP"; then
    echo "Ping from $SVDB to $SRVS is OK."
else
    echo "There is no ping from $SVDB to $SRVS."
    exit 4
fi

echo ""
read -n 1 -s -r -p "Press a whitespace to continue >>>"
echo ""



echo ">>>>> Step 7 - Check if the volume for $SVDB"
if docker volume inspect $VOLUME &> /dev/null; then
    echo "Volume $VOLUME is created"
else
    echo "Volume $VOLUME is not created"
fi

# Check if the volume 'mydb-data' is connected to the 'mydb' service
if docker compose config | grep -q "$VOLUME"; then
    echo "Volume $VOLUME is connected to the $SVDB service"
else
    echo "Volume $VOLUME is not connected to the $SVDB service"
fi

echo ""
read -n 1 -s -r -p "Press a whitespace to continue >>>"
echo ""



echo ">>>>> Step 8 - Healthchecks - r/w data perissions"

# Break mydb service by changing data file permissions
docker exec -it $SVDB sh -c "chmod 000 /var/lib/mysql/*"

echo "Check $SVDB container status/health after chmod 000:"
docker inspect --format='{{.State.Health.Status}}' $SVDB

# Fix MySQL service by returning permissions back
docker exec -it $SVDB sh -c "chmod 755 /var/lib/mysql/*"

echo "Ensure health check is okay:"
docker inspect --format='{{.State.Health.Status}}' $SVDB

echo ""
read -n 1 -s -r -p "Press a whitespace to continue >>>"
echo ""



echo ">>>>> Step 9 - Healthchecks - service_healthy condition"
python3 health-json_v2.py

