# Baxter Base Container

This container provides an interactive shell with ROS and catkin tools
preinstalled. If the Baxter SDK is not already present in `BXT_PATH`, it will be
installed automatically on first run.

## Getting Started
1. Copy [`.env`](.env) and [`docker-compose.yaml`](docker-compose.yaml) into the
   folder where you plan to run the container.
2. Edit the copied .env file ensuring:
   - `BAXTER_HOSTNAME` matches the robot's reachable hostname.
   - `LOCAL_UID`, `LOCAL_GID`, and `BXT_PATH` match your host user and desired
     workspace location.
3. (Optional) Create a `.bash_history` file with `touch .bash_history` and point
   `BASH_HISTORY` at it for
   persistent shell history.

Launch the container with:
```bash
docker compose run --rm baxter
```
The first run will install the Baxter SDK into `BXT_PATH` if it is not already
present.

## Key Environment Variables
- `LOCAL_UID` / `LOCAL_GID`: Host user and group IDs so files created in the
  container match host ownership.
- `BXT_PATH`: Catkin workspace path inside the container where the Baxter SDK
  should live.
- `BASH_HISTORY`: Optional path for a persistent Bash history file.
- `BAXTER_HOSTNAME`: Hostname of your Baxter robot. The container expects the
  robot to be reachable on the network at this address.
