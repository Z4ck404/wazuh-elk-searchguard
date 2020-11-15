# Wazuh Docker Copyright (C) 2020 Wazuh Inc. (License GPLv2)
FROM docker.elastic.co/kibana/kibana:7.9.1
USER kibana
ARG ELASTIC_VERSION=7.9.1
ARG WAZUH_VERSION=3.13.2

ARG WAZUH_APP_VERSION="${WAZUH_VERSION}_${ELASTIC_VERSION}"

WORKDIR /usr/share/kibana
RUN ./bin/kibana-plugin install https://packages.wazuh.com/wazuhapp/wazuhapp-${WAZUH_APP_VERSION}.zip
ARG SG_VERSION_KIBANA=45.0.0
RUN kibana-plugin install https://maven.search-guard.com/search-guard-kibana-plugin-release/com/floragunn/search-guard-kibana-plugin/${ELASTIC_VERSION}-${SG_VERSION_KIBANA}/search-guard-kibana-plugin-${ELASTIC_VERSION}-${SG_VERSION_KIBANA}.zip

WORKDIR /
USER root
COPY config/entrypoint.sh ./entrypoint.sh
RUN chmod 755 ./entrypoint.sh

ENV PATTERN="" \
    CHECKS_PATTERN="" \
    CHECKS_TEMPLATE="" \
    CHECKS_API="" \
    CHECKS_SETUP="" \
    EXTENSIONS_PCI="" \
    EXTENSIONS_GDPR="" \
    EXTENSIONS_AUDIT="" \
    EXTENSIONS_OSCAP="" \
    EXTENSIONS_CISCAT="" \
    EXTENSIONS_AWS="" \
    EXTENSIONS_VIRUSTOTAL="" \
    EXTENSIONS_OSQUERY="" \
    APP_TIMEOUT="" \
    WAZUH_SHARDS="" \
    WAZUH_REPLICAS="" \
    WAZUH_VERSION_SHARDS="" \
    WAZUH_VERSION_REPLICAS="" \
    IP_SELECTOR="" \
    IP_IGNORE="" \
    XPACK_RBAC_ENABLED="" \
    WAZUH_MONITORING_ENABLED="" \
    WAZUH_MONITORING_FREQUENCY="" \
    WAZUH_MONITORING_SHARDS="" \
    WAZUH_MONITORING_REPLICAS="" \
    ADMIN_PRIVILEGES=""

ARG XPACK_CANVAS="false"
ARG XPACK_LOGS="false"
ARG XPACK_INFRA="false"
ARG XPACK_ML="false"
ARG XPACK_DEVTOOLS="false"
ARG XPACK_MONITORING="false"
ARG XPACK_APM="false"
ARG XPACK_SECURITY_ENABLED="false"

ARG CHANGE_WELCOME="false"

COPY --chown=kibana:kibana ./config/wazuh_app_config.sh ./

RUN chmod +x ./wazuh_app_config.sh

COPY --chown=kibana:kibana ./config/kibana_settings.sh ./

RUN chmod +x ./kibana_settings.sh

COPY --chown=kibana:kibana ./config/xpack_config.sh ./

RUN chmod +x ./xpack_config.sh

RUN ./xpack_config.sh

COPY --chown=kibana:kibana ./config/welcome_wazuh.sh ./

RUN chmod +x ./welcome_wazuh.sh

RUN ./welcome_wazuh.sh
USER kibana
RUN NODE_OPTIONS="--max-old-space-size=2048" /usr/local/bin/kibana-docker --optimize

ENTRYPOINT ./entrypoint.sh
