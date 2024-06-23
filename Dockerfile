FROM rabbitmq:3-management

COPY .erlang.cookie /var/lib/rabbitmq/.erlang.cookie
COPY cluster-entrypoint.sh /usr/local/bin/cluster-entrypoint.sh

ENV RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
ENV RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}
ENV RABBITMQ_DEFAULT_VHOST=${RABBITMQ_DEFAULT_VHOST}

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]
