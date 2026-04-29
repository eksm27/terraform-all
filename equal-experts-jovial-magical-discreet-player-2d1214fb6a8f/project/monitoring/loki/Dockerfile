FROM grafana/loki:2.9.8

COPY loki-config.yml /etc/loki/loki-config.yml

EXPOSE 3100

ENTRYPOINT ["/usr/bin/loki"]
CMD ["-config.file=/etc/loki/loki-config.yml"]


FROM grafana/loki:2.9.8

COPY loki-config.yml /etc/loki/loki-config.yml

EXPOSE 3100

ENTRYPOINT ["/usr/bin/loki"]
CMD ["-config.file=/etc/loki/loki-config.yml"]