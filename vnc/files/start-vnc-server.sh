#!/bin/bash -e

if [[ -z "${BAXTER_HOSTNAME:-}" || "${BAXTER_HOSTNAME}" == "baxter_hostname.local" ]]; then
  echo "EXITING - Please edit the .env, modifying the 'BAXTER_HOSTNAME' variable to reflect Baxter's current hostname." >&2
  exit 1
fi

export DISPLAY=:20

# Start the X server
Xvfb "$DISPLAY" -screen 0 "${DISPLAY_GEOMETRY}x24" &

# Start the xfce environment
xfce4-panel &
xfdesktop &
xfwm4 &
xterm &

port="${VNC_PORT:-5900}"

args=(
  -display "${DISPLAY}"
  -rfbport "${port}"
  -forever
  -localhost
)

# If VNC_PASSWORD is set and non-empty, use it
if [[ -n "${VNC_PASSWORD}" ]]; then
  args+=( -passwd "${VNC_PASSWORD}" )
fi

exec x11vnc "${args[@]}"
