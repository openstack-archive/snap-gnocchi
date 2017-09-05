#!/bin/bash

set -ex

source $BASE_DIR/admin-openrc

DEBIAN_FRONTEND='noninteractive' sudo -E apt install --yes python-gnocchiclient

sudo mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS gnocchi;
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'localhost' \
  IDENTIFIED BY 'gnocchi';
GRANT ALL PRIVILEGES ON gnocchi.* TO 'gnocchi'@'%' \
  IDENTIFIED BY 'gnocchi';
EOF

while sudo [ ! -d /var/snap/gnocchi/common/etc/gnocchi/ ]; do sleep 0.1; done;
sudo cp -r $BASE_DIR/etc/snap-gnocchi/* /var/snap/gnocchi/common/etc/

openstack user show gnocchi || {
    openstack user create --domain default --password gnocchi gnocchi
    openstack role add --project service --user gnocchi admin
}

openstack service show metric || {
    openstack service create --name gnocchi --description "Metric Service" metric
    for endpoint in internal admin public; do
        openstack endpoint create --region RegionOne \
            metric $endpoint http://localhost:8041 || :
    done
}

# Manually define alias if snap isn't installed from snap store.
# Otherwise, snap store defines this alias automatically.
snap aliases gnocchi | grep gnocchi-upgrade || sudo snap alias gnocchi.upgrade gnocchi-upgrade

sudo gnocchi-upgrade

sudo systemctl restart snap.gnocchi.*

while ! nc -z localhost 8041; do sleep 0.1; done;
