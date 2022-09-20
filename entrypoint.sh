#!/bin/sh

set -e

if [ ! -f /etc/provisioned ]; then
    USER=user
    PASS="$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)"
    echo -n "$USER:$PASS" | chpasswd

    echo "=== Login information ==="
    echo "Username: $USER"
    echo "Password: $PASS"

    touch /etc/provisioned
fi

mkdir -p -m 0755 /run/sshd
exec /usr/sbin/sshd -D
