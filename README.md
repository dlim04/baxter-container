# Baxter Container

A container-based development environment for working with Rethink Robotics
Baxter robots. This container provides a CLI for running ROS and catkin commands
and integrates the Baxter SDK automatically.

## Features
- Interactive container for Baxter SDK, ROS, and catkin tools.
- Automatic Baxter SDK installation into `BXT_PATH` if not present.
- Docker Compose provided for easy container runs.
- UID/GID remapping so files created in the container match your host user.

## Prerequisites
- Host must be linux based system (tested on Debian and Ubuntu).
- Docker and Docker Compose installed on your host (see [Install Docker
Engine](https://docs.docker.com/engine/install/)).
- Host machine and Baxter robot must be on the same network segment (i.e. must
be reachable by ping).

## Quick Setup

1. **Copy the example files** into a new folder:
   - [docker-compose.yaml](docker-compose.yaml)
   - [.env](.env)

2. **Edit `.env`** or modify environment variables directly in
`docker-compose.yaml` to match your host system (see [Important .env
Variables](#important-env-variables)).

3. (Optional) Create a persistent bash history:
   ```bash
   touch .bash_history
   ```

4. (Optional) **Add an alias for convenience** in your `~/.bash_aliases` file:
   ```bash
   alias baxter='docker compose -f /path/to/docker-compose.yaml run --rm baxter'
   ```
   Reload your shell or run `source ~/.bash_aliases`.


## Running the Container
Use the alias:
```bash
baxter
```
or:
```bash
docker compose -f /path/to/docker-compose.yaml run --rm baxter
```
This drops you into a CLI with ROS and catkin tools. On first run, the container
checks `BXT_PATH` and installs the Baxter SDK into your chosen catkin workspace
if it is missing.

## Important .env Variables
- **LOCAL_UID**: The user ID of your host system (run `id -u`).
- **LOCAL_GID**: The group ID of your host system (run `id -g`).
- **BXT_PATH**: Path inside the container where the Baxter SDK should be
installed. If not present, the SDK will be installed automatically.
- **BASH_HISTORY**: Path of your persistent `.bash_history` file.
- **BAXTER_HOSTNAME**: The hostname of your Baxter robot (usually
`serial-number.local`).

## Tips & Troubleshooting
- **Permission errors?** 
  - Ensure that directory at `BXT_PATH` exists.
  - Ensure `LOCAL_UID` and `LOCAL_GID` in `.env` match your host user and group
  IDs (use `id -u` and `id -g`).
