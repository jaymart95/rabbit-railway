FROM rabbitmq:management-alpine

COPY .erlang.cookie /var/lib/rabbitmq/.erlang.cookie
COPY cluster-entrypoint.sh /usr/local/bin/cluster-entrypoint.sh
COPY src/rabbitmq/plugins /plugins/

RUN set -eux; \
    rabbitmq-plugins enable --offline rabbitmq_management rabbitmq_message_deduplication; \
    rm -f /etc/rabbitmq/conf.d/20-management_agent.disable_metrics_collector.conf; \
    cp /plugins/rabbitmq_management-*/priv/www/cli/rabbitmqadmin /usr/local/bin/rabbitmqadmin; \
    [ -s /usr/local/bin/rabbitmqadmin ]; \
    chmod +x /usr/local/bin/rabbitmqadmin; \
    apk add --no-cache python3; \
    rabbitmqadmin --version

ENV JOIN_CLUSTER_HOST=rabbitmq1.railway.internal
RUN chmod 755 /usr/local/bin/cluster-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]
CMD ["rabbitmq-server"]
