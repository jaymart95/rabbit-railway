#!/bin/bash

set -e

# Change .erlang.cookie permission
chmod 400 /usr/var/lib/rabbitmq/.erlang.cookie

# Get hostname from environment variable
HOSTNAME=rabbitmq1.railway.internal
echo "Starting RabbitMQ Server For host: " $HOSTNAME

if [ -z "$JOIN_CLUSTER_HOST" ]; then
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server &
    sleep 10
    rabbitmqctl wait --timeout 30000 /usr/var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
else
    /usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached
    sleep 10
    rabbitmqctl wait --timeout 30000 /usr/var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
    rabbitmqctl stop_app
    rabbitmqctl join_cluster rabbit@$JOIN_CLUSTER_HOST
    rabbitmqctl start_app
fi

# Keep foreground process active ...
tail -f /dev/null
