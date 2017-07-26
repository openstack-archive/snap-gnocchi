# The gnocchi snap

This repository contains the source code for the gnocchi snap.

Gnocchi is an open-source, multi-tenant timeseries, metrics and resources database. It provides an HTTP REST interface to create and manipulate the data. It is designed to store metrics at a very large scale while providing access to metrics and resources information and history.

## Installing this snap

The gnocchi snap can be installed directly from the snap store:

    sudo snap install --edge gnocchi

The gnocchi snap is working towards publication across tracks for
OpenStack releases. The edge channel for each track will contain the tip
of the OpenStack project's master branch, with the beta, candidate and
release channels being reserved for released versions. These three channels
will be used to drive the CI process for validation of snap updates. This
should result in an experience such as:

    sudo snap install --channel=ocata/stable gnocchi
    sudo snap install --channel=pike/edge gnocchi

## Configuring gnocchi

The gnocchi snap gets its default configuration from the following $SNAP
and $SNAP_COMMON locations:

### Insert trees of /snap/gnocchi/current/etc/ and
### /var/snap/gnocchi/common/etc. If the OpenStack service has an API
### that runs behind uwsgi+nginx, the trees may like like this:

    /snap/gnocchi/current/etc/
    └── gnocchi
        ├── gnocchi.conf
        └── ...

    /var/snap/gnocchi/common/etc/
    ├── gnocchi
    │   └── gnocchi.conf.d
    │       └── gnocchi-snap.conf
    ├── nginx
    │   ├── snap
    │   │   ├── nginx.conf
    │   │   └── sites-enabled
    │   │       └── gnocchi.conf
    └── uwsgi
        └── snap
            └── gnocchi-api.ini

### Add any details here on how to configure services for this snap.
### Insert a tree of /var/snap/gnocchi/common/etc with override files.
### If the OpenStack service has an API that runs behind uwsgi+nginx,
### the tree may like like this:

The gnocchi snap supports configuration updates via its $SNAP_COMMON writable
area. The default gnocchi configuration can be overridden as follows:

    /var/snap/gnocchi/common/etc/
    ├── gnocchi
    │   ├── gnocchi.conf.d
    │   │   ├── gnocchi-snap.conf
    │   │   ├── database.conf
    │   │   └── rabbitmq.conf
    │   └── gnocchi.conf
    ├── nginx
    │   ├── snap
    │   │   ├── nginx.conf
    │   │   └── sites-enabled
    │   │       └── gnocchi.conf
    │   ├── nginx.conf
    │   ├── sites-enabled
    │   │   └── gnocchi.conf
    └── uwsgi
        ├── snap
        │   └── gnocchi-api.ini
        └── gnocchi-api.ini

The gnocchi configuration can be overridden or augmented by writing
configuration snippets to files in the gnocchi.conf.d directory.

Alternatively, gnocchi configuration can be overridden by adding a full
gnocchi.conf file to the gnocchi/ directory. If overriding in this way, you'll
need to either point this config file at additional config files located in $SNAP,
or add those to $SNAP_COMMON as well.

The gnocchi nginx configuration can be overridden by adding an nginx/nginx.conf
and new site config files to the nginx/sites-enabled directory. In this case the
nginx/nginx.conf file would include that sites-enabled directory. If
nginx/nginx.conf exists, nginx/snap/nginx.conf will no longer be used.

The gnocchi uwsgi configuration can be overridden similarly by adding a
uwsgi/gnocchi.ini file. If uwsgi/gnocchi.ini exists, uwsgi/snap/gnocchi.ini
will no longer be used.

## Logging gnocchi

The services for the gnocchi snap will log to its $SNAP_COMMON writable area:
/var/snap/gnocchi/common/log.

## Restarting gnocchi services

To restart all gnocchi services:

    sudo systemctl restart snap.gnocchi.*

or an individual service can be restarted by dropping the wildcard and
specifying the full service name.

## Building the gnocchi snap

Simply clone this repository and then install and run snapcraft:

    git clone https://github.com/openstack-snaps/snap-gnocchi
    sudo apt install snapcraft
    cd snap-gnocchi
    snapcraft

## Support

Please report any bugs related to this snap at:
[Launchpad](https://bugs.launchpad.net/snap-gnocchi/+filebug).

Alternatively you can find the OpenStack Snap team in `#openstack-snaps` on
Freenode IRC.
