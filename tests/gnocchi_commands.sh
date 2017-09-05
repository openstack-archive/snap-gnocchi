#!/bin/bash

set -ex

source $BASE_DIR/admin-openrc

gnocchi resource list | grep generic

gnocchi metric create --archive-policy-name high
gnocchi metric list | grep high
