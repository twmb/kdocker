ARG OPENJDK=11-jre-slim
FROM openjdk:${OPENJDK}

ARG KAFKA_DL_DIR=3.0.0
ARG KAFKA_DL_FILE=kafka_2.13-3.0.0
ARG KAFKA_SHA_CMD=sha512sum
ARG KAFKA_DL_SHA=86cdeb04af123399858d03431e9777948c1c40ec0d843966cf9bd90b8235b47ebbb5cb96d1f0660710b9286da86bbb5ee65e21e757606f5a1e67f970ae5cf57c

RUN set -exu; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    curl \
    jq \
    dumb-init \
    gosu; \
  curl -s -o kafka.tar.gz $(curl -s "https://www.apache.org/dyn/closer.cgi?path=/kafka/${KAFKA_DL_DIR}/${KAFKA_DL_FILE}.tgz&as_json=1" | jq -r '.preferred + .path_info') ; \
  gosu nobody true; \
  apt-get remove -y --purge curl jq; \
  apt-get autoremove -y; \
  rm -rf /var/lib/apt/lists/*; \
  [ "$(${KAFKA_SHA_CMD} kafka.tar.gz | cut -f1 -d' ')" = "${KAFKA_DL_SHA}" ]; \
  tar xzf kafka.tar.gz; \
  rm kafka.tar.gz; \
  mv ${KAFKA_DL_FILE} /kafka; \
  groupadd -r kafka --gid=1000; \
  useradd -r -g kafka --uid=1000 kafka; \
  rm /kafka/config/server.properties; \
  chown -R kafka:kafka /kafka

EXPOSE 9092

ENV \
  KPROP_BROKER_ID=0 \
  KPROP_NUM_NETWORK_THREADS=3 \
  KPROP_NUM_IO_THREADS=8 \
  KPROP_SOCKET_SEND_BUFFER_BYTES=102400 \
  KPROP_SOCKET_RECEIVE_BUFFER_BYTES=102400 \
  KPROP_SOCKET_REQUEST_MAX_BYTES=104857600 \
  KPROP_LOG_DIRS=/tmp/kafka-logs \
  KPROP_NUM_PARTITIONS=1 \
  KPROP_NUM_RECOVERY_THREADS_PER_DATA_DIR=1 \
  KPROP_OFFSETS_TOPIC_REPLICATION_FACTOR=1 \
  KPROP_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1 \
  KPROP_TRANSACTION_STATE_LOG_MIN_ISR=1 \
  KPROP_LOG_RETENTION_HOURS=168 \
  KPROP_LOG_SEGMENT_BYTES=1073741824 \
  KPROP_LOG_RETENTION_CHECK_INTERVAL_MS=300000 \
  KPROP_ZOOKEEPER_CONNECT=localhost:2181 \
  KPROP_ZOOKEEPER_CONNECTION_TIMEOUT_MS=6000 \
  KPROP_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  KPROP_LISTENERS=PLAINTEXT://localhost:9092

WORKDIR /kafka
ENTRYPOINT ["gosu", "kafka", "dumb-init", "--", "/kafka/entrypoint.sh"]
COPY entrypoint.sh /kafka/entrypoint.sh
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
