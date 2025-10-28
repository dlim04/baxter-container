#!/bin/bash -e

if [[ -z "${BAXTER_HOSTNAME:-}" || "${BAXTER_HOSTNAME}" == "baxter_hostname.local" ]]; then
  echo "EXITING - Please edit the .env, modifying the 'BAXTER_HOSTNAME' variable to reflect Baxter's current hostname." >&2
  exit 1
fi

# Set the VNC port number based on environment variable or default to 5900
port="${VNC_PORT:-5900}"

# Set the display number based on the VNC port
# (e.g. 5900 -> :20, 5901 -> :21, etc.)
display_number=$((port - 5880))
export DISPLAY=":${display_number}"

echo "--- Starting on VNC Port ${port} (X Display ${DISPLAY}) ---"

# Start the X server
Xvfb "$DISPLAY" -screen 0 "${DISPLAY_GEOMETRY}x24" &
sleep 1 # Give Xvfb time to start

# Start the xfce environment
xfce4-panel &
xfdesktop &
xfwm4 &
xterm &

sleep 1 # Give Xfce time to start

# Assign arguments for X11vnc
args=(
  -display "${DISPLAY}"
  -rfbport "${port}"
  -rfbportv6 "${port}"
  -forever
  -localhost
)

# If VNC_PASSWORD is set and non-empty, use it
if [[ -n "${VNC_PASSWORD}" ]]; then
  args+=( -passwd "${VNC_PASSWORD}" )
fi

# Start the VNC server
exec x11vnc "${args[@]}"
