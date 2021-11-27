#!/bin/bash

set -e

CONFIG="$ZOOCFGDIR/zoo.cfg"

opt() {
    if [[ -n "$2" ]]; then
        echo "$1=$2" >> "$CONFIG"
    fi
}

if [[ ! -f "$CONFIG" ]]; then
    # minimum configuration
    opt "clientPort" "$ZK_CLIENT_PORT"
    opt "secureClientPort" "$ZK_SECURE_CLIENT_PORT"
    opt "dataDir" "/zk/data"
    opt "tickTime" "$ZK_TICK_TIME"

    # advanced configuration
    opt "dataLogDir" "/zk/datalog"
    opt "globalOutstandingLimit" "$ZK_GLOBAL_OUTSTANDING_LIMIT"
    opt "preAllocSize" "$ZK_PRE_ALLOC_SIZE"
    opt "snapCount" "$ZK_SNAP_COUNT"
    opt "maxClientCnxns" "$ZK_MAX_CLIENT_CNXNS"
    opt "clientPortAddress" "$ZK_CLIENT_PORT_ADDRESS"
    opt "minSessionTimeout" "$ZK_MIN_SESSION_TIMEOUT"
    opt "maxSessionTimeout" "$ZK_MAX_SESSION_TIMEOUT"
    opt "fsync.warningthresholdms" "$ZK_FSYNC_WARNING_THRESHOLD_MS"
    opt "autopurge.snapRetainCount" "$ZK_AUTOPURGE_SNAP_RETAIN_COUNT"
    opt "autopurge.purgeInterval" "$ZK_AUTOPURGE_PURGE_INTERVAL"
    opt "syncEnabled" "$ZK_SYNC_ENABLED"
    opt "zookeeper.extendedTypesEnabled" "$ZK_EXTENDED_TYPES_ENABLED"
    opt "zookeeper.emulate353TTLNodes" "$ZK_EMULATE_353_TTL_NODES"
    opt "serverCnxnFactory" "$ZK_SERVER_CNXN_FACTORY"

    # cluster options
    opt "electionAlg" "$ZK_ELECTION_ALG"
    opt "initLimit" "$ZK_INIT_LIMIT"
    opt "leaderServes" "$ZK_LEADER_SERVES"
    for server in $ZK_SERVERS; do echo "$server" >> "$CONFIG"; done
    opt "syncLimit" "$ZK_SYNC_LIMIT"
    for group in $ZK_GROUPS; do echo "$group" >> "$CONFIG"; done
    for weight in $ZK_WEIGHTS; do echo "$weight" >> "$CONFIG"; done
    opt "cnxTimeout" "$ZK_CNX_TIMEOUT"
    opt "standaloneEnabled" "$ZK_STANDALONE_ENABLED"
    opt "reconfigEnabled" "$ZK_RECONFIG_ENABLED"
    opt "4lw.commands.whitelist" "$ZK_4LW_COMMANDS_WHITELIST"

    # TODO ssl options

    # unsafe options
    opt "forceSync" "$ZK_FORCE_SYNC"
    opt "jute.maxbuffer" "$ZK_JUTE_MAX_BUFFER"
    opt "skipACL" "$ZK_SKIP_ACL"
    opt "quorumListenOnAllIPs" "$ZK_QUORUM_LISTEN_ON_ALL_IPS"
fi

# write myid if it does not exist; default -1
if [[ ! -f "/zk/data/myid" ]]; then
    echo "${ZK_MY_ID:-1}" > "/zk/data/myid"
fi

# TODO log4j stuff

exec "$@"
