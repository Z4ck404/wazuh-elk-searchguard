#!/bin/bash
# Wazuh Docker Copyright (C) 2020 Wazuh Inc. (License GPLv2)

elastic_config_file="/usr/share/elasticsearch/config/elasticsearch.yml"

remove_single_node_conf(){
  if grep -Fq "discovery.type" $1; then
    sed -i '/discovery.type\: /d' $1
  fi
}

remove_cluster_config(){
  sed -i '/# cluster node/,/# end cluster config/d' $1
}

# If Elasticsearch cluster is enable, then set up the elasticsearch.yml
if [[ $ELASTIC_CLUSTER == "true" && $CLUSTER_NODE_MASTER != "" && $CLUSTER_NODE_DATA != "" && $CLUSTER_NODE_INGEST != "" && $CLUSTER_MASTER_NODE_NAME != "" ]]; then
  # Remove the old configuration
  remove_single_node_conf $elastic_config_file
  remove_cluster_config $elastic_config_file

if [[ $CLUSTER_NODE_MASTER == "true" ]]; then
# Add the master configuration
# cluster.initial_master_nodes for bootstrap the cluster
cat > $elastic_config_file << EOF
# cluster node
network.host: $CLUSTER_NETWORK_HOST
node.name: $CLUSTER_MASTER_NODE_NAME
node.master: $CLUSTER_NODE_MASTER
cluster.initial_master_nodes:
  - $CLUSTER_MASTER_NODE_NAME

xpack.license.self_generated.type: basic
xpack.security.enabled: false

## Search Guard
searchguard.enterprise_modules_enabled: true

searchguard.ssl.transport.keystore_filepath: sg/node-0-keystore.jks
searchguard.ssl.transport.truststore_filepath: sg/truststore.jks
searchguard.ssl.transport.enforce_hostname_verification: false

searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,l=tEst,C=De

searchguard.restapi.roles_enabled:
  - SGS_ALL_ACCESS
# end cluster config"
EOF

elif [[ $CLUSTER_NODE_NAME != "" ]];then
# Remove the old configuration
remove_single_node_conf $elastic_config_file
remove_cluster_config $elastic_config_file

cat > $elastic_config_file << EOF
# cluster node
network.host: $CLUSTER_NETWORK_HOST
node.name: $CLUSTER_NODE_NAME
node.master: false 
discovery.seed_hosts:
  - $CLUSTER_MASTER_NODE_NAME
  - $CLUSTER_NODE_NAME
xpack.license.self_generated.type: basic
xpack.security.enabled: false

## Search Guard
searchguard.enterprise_modules_enabled: true

searchguard.ssl.transport.keystore_filepath: sg/node-0-keystore.jks
searchguard.ssl.transport.truststore_filepath: sg/truststore.jks
searchguard.ssl.transport.enforce_hostname_verification: false

searchguard.authcz.admin_dn:
  - CN=kirk,OU=client,O=client,l=tEst,C=De

searchguard.restapi.roles_enabled:
  - SGS_ALL_ACCESS
# end cluster config"
EOF
fi
# If the cluster is disabled, then set a single-node configuration
else
  # Remove the old configuration
  remove_single_node_conf $elastic_config_file
  remove_cluster_config $elastic_config_file
  echo "discovery.type: single-node" >> $elastic_config_file
fi