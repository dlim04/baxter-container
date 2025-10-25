FROM ros:indigo-ros-base
LABEL maintainer="David Lim <dlim04@qub.ac.uk>" \
      description="A container-based development environment for working with Rethink Robotics Baxter robots."

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Install Packages
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
      avahi-daemon \
      curl \
      g++ \
      libnss-mdns \
      ros-indigo-control-msgs \
      ros-indigo-joystick-drivers \
      ros-indigo-baxter-sdk \
      > /dev/null && \
      apt-get -qq clean

# Install gosu
ARG GOSU_VERSION=1.19
RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${ARCH}" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Install tini
ARG TINI_VERSION=v0.19.0
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -o /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Create user, add to groups dialout and sudo, and configure sudoers.
RUN adduser --disabled-password --gecos '' user && \
    usermod -aG dialout,plugdev,sudo user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Set user for what comes next
USER user

# Update the rosdep database
RUN rosdep update

# Environment variables
ENV HOME=/home/user
ENV ROS_WS=${HOME}/ros_ws
ENV PATH=${HOME}/.local/bin:${PATH}
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Add baxter SDK intallation script.
COPY --chown=root:root files/install-baxter-sdk.sh /usr/local/bin/install-baxter-sdk.sh
# Add baxter startup script.
COPY --chown=root:root files/baxter.sh /usr/local/bin/baxter.sh
# Add entrypoint script.
COPY --chown=root:root files/entrypoint.sh /usr/local/bin/entrypoint.sh

# Working directory
WORKDIR ${ROS_WS}

# Start a bash
USER root
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash", "--login"]
