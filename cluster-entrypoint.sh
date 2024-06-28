#!/bin/bash

set -e

# Change .erlang.cookie permission
chmod 400 /usr/var/lib/rabbitmq/.erlang.cookie

# Use the FQDN provided by Railway
HOSTNAME=$(hostname -f)
echo "Starting RabbitMQ Server for host: $HOSTNAME"

if [ -z "$JOIN_CLUSTER_HOST" ]; then
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server &
    sleep 30
    rabbitmqctl wait --timeout 60000 /usr/var/lib/rabbitmq/mnesia/rabbitmq2@$HOSTNAME.pid
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached
    sleep 30
    rabbitmqctl wait --timeout 60000 /usr/var/lib/rabbitmq/mnesia/rabbitmq2@$HOSTNAME.pid
    echo "Stopping RabbitMQ application on node $HOSTNAME..."
    rabbitmqctl stop_app
    echo "Joining node $HOSTNAME to cluster $JOIN_CLUSTER_HOST..."
    rabbitmqctl join_cluster $JOIN_CLUSTER_HOST
    if [ $? -ne 0 ]; then
        echo "Error joining cluster. Exiting."
        exit 1
    fi
    echo "Starting RabbitMQ application on node $HOSTNAME..."
    rabbitmqctl start_app
fi

# Keep foreground process active ...
tail -f /dev/null
