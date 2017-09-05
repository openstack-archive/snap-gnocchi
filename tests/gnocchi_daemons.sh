#!/bin/bash

set -ex

ret=0
DAEMONS=('snap.gnocchi.uwsgi' 'snap.gnocchi.nginx' 'snap.gnocchi.metricd' 'snap.gnocchi.statsd')
for daemon in "${DAEMONS[@]}"; do
    sudo systemctl restart $daemon
    TIMEOUT=50
    while [ "$TIMEOUT" -gt 0 ]; do
        if systemctl is-active $daemon > /dev/null; then
            echo "OK"
            break
        fi
        TIMEOUT=$((TIMEOUT - 1))
        sleep 0.1
    done

    if [ "$TIMEOUT" -le 0 ]; then
        echo "ERROR: ${daemon} IS NOT RUNNING"
        ret=1
    fi
done

exit $ret
