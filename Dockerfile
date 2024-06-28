FROM rabbitmq:management-alpine

COPY .erlang.cookie /usr/var/lib/rabbitmq/.erlang.cookie
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

ENV RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
ENV RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}
ENV RABBITMQ_NODENAME=rabbitmq-cluster1

RUN chmod 755 /usr/local/bin/cluster-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]
CMD ["rabbitmq-server"]
