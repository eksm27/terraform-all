#!/usr/bin/env bash
#Full corrected run.sh
set -eu

NET=monitoring

echo ">> creating docker network if missing"
docker network inspect "$NET" >/dev/null 2>&1 || docker network create "$NET"

echo ">> building images"
docker build -t fastapi-app      ./app
docker build -t local-prometheus ./monitoring/prometheus
docker build -t local-loki       ./monitoring/loki
docker build -t local-promtail   ./monitoring/promtail
docker build -t local-grafana    ./monitoring/grafana

echo ">> restarting containers"
docker rm -f loki prometheus fastapi-app promtail grafana >/dev/null 2>&1 || true

echo ">> starting loki"
docker run -d --name loki \
  --network "$NET" \
  -p 3100:3100 \
  -v loki-data:/loki \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
  --restart unless-stopped \
  local-loki

echo ">> starting fastapi-app"
docker run -d --name fastapi-app \
  --network "$NET" \
  -p 8080:8080 \
  -e LOG_LEVEL=INFO \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
  --restart unless-stopped \
  fastapi-app

echo ">> starting prometheus"
docker run -d --name prometheus \
  --network "$NET" \
  -p 9090:9090 \
  -v prometheus-data:/prometheus \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
  --restart unless-stopped \
  local-prometheus

echo ">> starting promtail"
docker run -d --name promtail \
  --network "$NET" \
  -v /var/lib/docker/containers:/var/lib/docker/containers:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
  --restart unless-stopped \
  local-promtail

echo ">> starting grafana"
docker run -d --name grafana \
  --network "$NET" \
  -p 3000:3000 \
  -v grafana-data:/var/lib/grafana \
  --log-driver json-file --log-opt max-size=10m --log-opt max-file=3 \
  --restart unless-stopped \
  local-grafana

echo
docker ps --filter network="$NET" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
echo
echo "App:        http://localhost:8080/health"
echo "Prometheus: http://localhost:9090"
echo "Loki:       http://localhost:3100/ready"
echo "Grafana:    http://localhost:3000   admin / admin"