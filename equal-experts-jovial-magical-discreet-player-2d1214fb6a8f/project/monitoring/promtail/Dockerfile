FROM grafana/promtail:latest

# Copy config
COPY promtail-config.yml /etc/promtail/promtail-config.yml

# Set Docker API version to avoid client mismatch
ENV DOCKER_API_VERSION=1.44

EXPOSE 9080

ENTRYPOINT ["/usr/bin/promtail"]
CMD ["-config.file=/etc/promtail/promtail-config.yml"]