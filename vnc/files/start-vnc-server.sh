#!/bin/bash -e

if [[ -z "${BAXTER_HOSTNAME:-}" || "${BAXTER_HOSTNAME}" == "baxter_hostname.local" ]]; then
  echo "EXITING - Please edit the .env, modifying the 'BAXTER_HOSTNAME' variable to reflect Baxter's current hostname." >&2
  exit 1
fi

port="${VNC_PORT:-5900}"

args=(
  -create
  -env "FD_GEOM=${DISPLAY_GEOMETRY}"
  -env FD_DEPTH=24
  -env FD_PROG=/usr/bin/startxfce4
  -rfbport "${port}"
  -forever
  -localhost
)

# If VNC_PASSWORD is set and non-empty, use it
if [[ -n "${VNC_PASSWORD}" ]]; then
  args+=( -passwd "${VNC_PASSWORD}" )
fi

exec x11vnc "${args[@]}"
