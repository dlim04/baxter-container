# Baxter VNC Container

This container launches an XFCE session that can be reached over VNC and
includes ROS and catkin tools. If the Baxter SDK is not already present in
`BXT_PATH`, it will be installed automatically on first run.

## Getting Started
1. Copy [`.env`](.env) and [`docker-compose.yaml`](docker-compose.yaml) into the
   folder where you plan to run the container.
2. Update the copied `.env`, ensuring:
   - `BAXTER_HOSTNAME` matches the robot's reachable hostname. The VNC startup
     script exits if this variable is unset or still `baxter_hostname.local`.
   - `LOCAL_UID`, `LOCAL_GID`, and `BXT_PATH` match your host user and desired
     workspace location.
   - Optionally set `VNC_PASSWORD` if you want the server gated by a password.
3. (Optional) Create a `.bash_history` file with `touch .bash_history` and point
   `BASH_HISTORY` at it for
   persistent shell history.

Start the desktop environment by running the following command in the same
directory as your `docker-compose.yaml`:
```bash
docker compose up
```
Stop it with:
```bash
docker compose down
```

## Connecting Via VNC
- Install a VNC client on the machine you will use to connect.
  [TigerVNC](https://tigervnc.org/) works well on Windows and Linux, and macOS
  includes the Screen Sharing app which can connect to VNC servers.
- Default display size is controlled by `DISPLAY_GEOMETRY` (for example,
  `1920x1080`).
- The server binds to `localhost` only. Connect from the Docker host itself or
  create an SSH tunnel to forward `${VNC_PORT}` to your local machine, then
  point the client at `localhost:${VNC_PORT}`.
- If `VNC_PASSWORD` is empty, no authentication is required.

## Troubleshooting
- If you see an immediate exit with the message about updating `.env`, verify
  `BAXTER_HOSTNAME` has been set to the robot's actual hostname.
- Ensure Docker is allowed to bind to the chosen `VNC_PORT` and that no other
  process is using it on the host.
