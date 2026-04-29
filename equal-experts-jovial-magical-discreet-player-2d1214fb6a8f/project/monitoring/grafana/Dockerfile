FROM grafana/grafana:10.4.2

# Pre-bake datasources, dashboard provider and the starter dashboard
COPY provisioning/ /etc/grafana/provisioning/
COPY dashboards/   /var/lib/grafana/dashboards/

ENV GF_SECURITY_ADMIN_USER=admin \
    GF_SECURITY_ADMIN_PASSWORD=admin \
    GF_USERS_ALLOW_SIGN_UP=false

EXPOSE 3000
