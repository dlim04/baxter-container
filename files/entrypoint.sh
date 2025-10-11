#!/bin/bash -e

# Assigns the container user's UID and GID based on the values of $LOCAL_UID
# and $LOCAL_GID. If these variables aren't defined, it defaults both to 1000,
# which is typically the UID/GID of the first user on Ubuntu systems.

USER_ID=${LOCAL_UID:-1000}
GROUP_ID=${LOCAL_GID:-1000}

[[ "$USER_ID" == "1000" ]] || usermod -u $USER_ID -o -m -d /home/user user
[[ "$GROUP_ID" == "1000" ]] || groupmod -g $GROUP_ID user

cat <<EOF > /tmp/user-startup.sh
#!/bin/bash -e

# Configure development environment
cd "$ROS_WS"
source /opt/ros/indigo/setup.bash
printf '\nsource /usr/local/bin/baxter.sh $BAXTER_HOSTNAME\n' | tee -a '/home/user/.bashrc' > /dev/null

exec "\$@"
EOF

chmod +x /tmp/user-startup.sh

# Run the script as the remapped user
exec /usr/local/bin/tini -- /usr/local/bin/gosu user /tmp/user-startup.sh "$@"
