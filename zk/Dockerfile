ARG OPENJDK=11-jre-slim
FROM openjdk:${OPENJDK}

ARG ZK_DL_DIR=zookeeper-3.7.0
ARG ZK_DL_FILE=apache-zookeeper-3.7.0-bin
ARG ZK_SHA_CMD=sha512sum
ARG ZK_DL_SHA=64e2701c019ed46f45f4d53b2c5eaeaf7cf48c342bbafa032a0819d527fc77caebfada6bdad34e5171e6d838f40b16c95b62ce378b53dfc827af2d60cec0b17c

# netcat exists for allowing healthchecks with
# echo ruok | nc -w 1 127.0.0.1 2181 | grep imok
# see 31z4/zookeeper-docker#66
# however zk fails fast, so this is debatably necessary
RUN set -exu; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    curl \
    jq \
    netcat \
    dumb-init \
    gosu; \
  curl -s -o zk.tar.gz $(curl -s "https://www.apache.org/dyn/closer.cgi?path=/zookeeper/${ZK_DL_DIR}/${ZK_DL_FILE}.tar.gz&as_json=1" | jq -r '.preferred + .path_info') ; \
  gosu nobody true; \
  apt-get remove -y --purge curl jq; \
  apt-get autoremove -y; \
  rm -rf /var/lib/apt/lists/*; \
  [ "$(${ZK_SHA_CMD} zk.tar.gz | cut -f1 -d' ')" = "${ZK_DL_SHA}" ]; \
  tar xzf zk.tar.gz; \
  rm zk.tar.gz; \
  mkdir -p /zk/conf /zk/data /zk/datalog; \
  mv ${ZK_DL_FILE} /zk/zookeeper; \
  groupadd -r zookeeper --gid=1000; \
  useradd -r -g zookeeper --uid=1000 zookeeper; \
  chown -R zookeeper:zookeeper /zk

EXPOSE 2181 2281 2888 3888 8080

ENV \
  ZK_SERVERS="server.1=localhost:2888:3888;2181" \
  ZK_CLIENT_PORT=2181 \
  ZK_TICK_TIME=2000 \
  ZK_INIT_LIMIT=10 \
  ZK_SYNC_LIMIT=5


ENV PATH=$PATH:/zk/zookeeper/bin \
  ZOOCFGDIR=/zk/conf

WORKDIR /zk/zookeeper/bin
ENTRYPOINT ["gosu", "zookeeper", "dumb-init", "--", "/zk/entrypoint.sh"]

COPY entrypoint.sh /zk/entrypoint.sh
CMD ["zkServer.sh", "start-foreground"]
