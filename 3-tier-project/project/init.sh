# CLEAN

cd db
docker build -t user-db .

cd ../app
docker build -t app-api .

cd ../web
docker build -t web-app .

docker rm -f $(docker ps -aq)
docker network rm mynet || true

# NETWORK
docker network create mynet

# DB
docker run -d --name db-service --network mynet user-db

# WAIT FOR DB
sleep 15

# APP
docker run -d \
--name app-service \
--network mynet \
-p 9090:9090 \
-e CONFIG_JSON=/app/configs/app-config.json \
app-api

# WEB
docker run -d \
--name web-service \
--network mynet \
-p 8080:8080 \
-e CONFIG_JSON=/usr/share/nginx/config/web-config.json \
web-app