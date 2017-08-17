#!/bin/bash

set -ex

DAEMONS=('snap.gnocchi.api.service', 'snap.gnocchi.metricd.service')
ret=0

sudo mysql -u root <<EOF
DROP DATABASE IF EXISTS gnocchi;
CREATE DATABASE gnocchi;
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'localhost' \
  IDENTIFIED BY 'changeme';
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'%' \
  IDENTIFIED BY 'changeme';
EOF

while sudo [ ! -d /var/snap/gnocchi/common/etc/gnocchi/ ]; do sleep 0.1; done;
# TODO: this may not be the right dir -- gnocchi doesn't seem to be
# able to see the indexer url that we set (or it might just be the
# wrong file).
sudo cp -r $BASE_DIR/etc/snap-gnocchi/* /var/snap/gnocchi/common/etc/

gnocchi.gnocchi-upgrade

for daemon in "${DAEMONS[@]}"; do
    systemctl restart $daemon
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
