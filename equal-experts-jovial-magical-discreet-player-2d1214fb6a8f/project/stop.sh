#!/usr/bin/env bash
docker rm -f fastapi-app prometheus loki promtail grafana 2>/dev/null || true
docker network rm monitoring 2>/dev/null || true
echo "stopped."