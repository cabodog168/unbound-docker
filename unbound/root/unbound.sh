#!/bin/sh
/usr/local/unbound/unbound.d/sbin/unbound-anchor -a /usr/local/unbound/iana.d/root.key
/usr/local/unbound/unbound.d/sbin/unbound_exporter -unbound.ca "" -unbound.cert "" -unbound.host "unix:///run/unbound/unbound.ctl" &
/usr/local/unbound/unbound.d/sbin/unbound -d -c /usr/local/unbound/unbound.conf &
wait -n
exit $?

