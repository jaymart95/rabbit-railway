FROM rabbitmq:management

WORKDIR /usr

COPY .erlang.cookie /usr/var/lib/rabbitmq/.erlang.cookie
COPY cluster-entrypoint.sh /usr/local/bin/cluster-entrypoint.sh

ENV RABBITMQ_DEFAULT_USER=${RABBITMQ_DEFAULT_USER}
ENV RABBITMQ_DEFAULT_PASS=${RABBITMQ_DEFAULT_PASS}

RUN chmod 755 /usr/local/bin/cluster-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/cluster-entrypoint.sh"]
