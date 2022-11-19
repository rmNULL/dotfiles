#!/usr/bin/env bash
# -*- sh -*-
set -eu

## Exit codes reference
## 1: Failed to find password for the given host
## 2: Hostname not supported

emacs_server_name="${EMACS_DEFAULT_SERVER_NAME:-${HOSTNAME}}"
host="$1"

if [[ "$host" =~ ^[0-9a-zA-Z_.]*$ ]]
then
    code="(iduh/lookup-password :host \"$host\")"
    quoted_pass=$(emacsclient -s "$emacs_server_name" -e "$code")
else
    echo "$host is not supported for password lookup"
    exit 2
fi

if [[ "$quoted_pass" != "nil" ]]
then
    echo "$quoted_pass" | sed -e 's/"//g'
else
    exit 1
fi
