#!/bin/bash

chown -R default.default /home/default

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

