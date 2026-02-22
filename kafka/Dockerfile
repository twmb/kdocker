ARG OPENJDK=25-slim
FROM openjdk:${OPENJDK}

ARG KAFKA_DL_DIR=4.0.0
ARG KAFKA_DL_FILE=kafka_2.13-4.0.0
ARG KAFKA_DL_SHA=00722ab0a6b954e0006994b8d589dcd8f26e1827c47f70b6e820fb45aa35945c19163b0f188caf0caf976c11f7ab005fd368c54e5851e899d2de687a804a5eb9

#ARG KAFKA_DL_DIR=3.9.0
#ARG KAFKA_DL_FILE=kafka_2.13-3.9.0
#ARG KAFKA_DL_SHA=5324c1f44d4c84ea469712c2cc3d2d15545c3716edbb5353722df9c661fcc78b031fcf07d1c4f0309c5fdb32686665dfb0cffe55210cd3a1fe2a370538cb4e6d

# ARG KAFKA_DL_DIR=3.8.0
# ARG KAFKA_DL_FILE=kafka_2.13-3.8.0
# ARG KAFKA_DL_SHA=0a33b7be7b6fa53249ba80f9d02cda71ed81927c160aa6ee9be1e3d3c1c4b50466ffc905293143fd88ceac7f5e7d8f5bec28ef972addd3c459cc8b1291e738aa

# ARG KAFKA_DL_DIR=3.7.1
# ARG KAFKA_DL_FILE=kafka_2.13-3.7.1
# ARG KAFKA_DL_SHA=78e985235d245ba9e2951a82e723a62b8aba8b74a2c8376f7271906af715a36de9142c446096f13fd4bff3a4c10f1d080eb924e91e2256ec2db779906fd6737d

# ARG KAFKA_DL_DIR=3.7.0
# ARG KAFKA_DL_FILE=kafka_2.13-3.7.0
# ARG KAFKA_DL_SHA=b8679283a2d8dab86e7c636b2c688fe9d9e64ac437241f65ef7a1733f4d26a2bd415eefa04f09f1911373bcd2a5dbc3838c76347f68656425c09202cd290ce91

# ARG KAFKA_DL_DIR=3.6.0
# ARG KAFKA_DL_FILE=kafka_2.13-3.6.0
# ARG KAFKA_DL_SHA=98d20f475bccc11eb3cf05362112c788eea7bfc88abddba66cfcfb48880d3bb97918a90d44eb7c1720527bebca93dd231002b5159876f6ee8b7fcd91cc1b0644

# ARG KAFKA_DL_DIR=3.5.1
# ARG KAFKA_DL_FILE=kafka_2.13-3.5.1
# ARG KAFKA_DL_SHA=b6ceb010a5fe1791843cbc53d34d35993e97e03f9518344b4b5bdf7146d0a4e866cd2d4760cab319d8b3323a5bf53037a78fed88c9384381aea2cd0366877763

ARG KAFKA_SHA_CMD=sha512sum
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
  KPROP_GROUP_INITIAL_REBALANCE_DELAY_MS=0 \
  KPROP_LISTENERS=PLAINTEXT://localhost:9092

WORKDIR /kafka
ENTRYPOINT ["gosu", "kafka", "dumb-init", "--", "/kafka/entrypoint.sh"]
COPY entrypoint.sh /kafka/entrypoint.sh
CMD ["bin/kafka-server-start.sh", "config/server.properties"]
