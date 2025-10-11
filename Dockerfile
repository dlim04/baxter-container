FROM ros:indigo-ros-base
LABEL maintainer="David Lim <dlim04@qub.ac.uk>"

ENV DEBIAN_FRONTEND noninteractive

USER root

# Install Packages
#
# Seems like there's an issue with the packages.ros.org key
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
      wget \
      > /dev/null && \
    sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list' && \
    wget -q http://packages.ros.org/ros.key -O - | apt-key add - && \
    apt-get update && \
    apt-get -y --force-yes --no-install-recommends install \
      avahi-daemon \
      curl \
      g++ \
      libnss-mdns \
      python-argparse \
      python-vcstools \
      ros-indigo-control-msgs \
      ros-indigo-joystick-drivers \
      ros-indigo-baxter-sdk \
      && \
      apt-get -qq clean

# Create user, add to groups dialout and sudo, and configure sudoers.
RUN adduser --disabled-password --gecos '' user && \
    usermod -aG dialout,plugdev,sudo user && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Set desired gosu version
ENV GOSU_VERSION=1.19

# Install gosu
RUN ARCH="$(dpkg --print-architecture)" && \
    curl -fsSL "https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-${ARCH}" -o /usr/local/bin/gosu && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true

# Set desired tini version
ENV TINI_VERSION=v0.19.0

# Install tini
RUN curl -fsSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini -o /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini

# Set user for what comes next
USER user

# Environment variables
ENV HOME                /home/user
ENV ROS_WS              ${HOME}/ros_ws
ENV                     PATH="${HOME}/.local/bin:${PATH}"
ENV                     LC_ALL=C.UTF-8
ENV                     LANG=C.UTF-8
WORKDIR                 ${HOME}

RUN rosdep update

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
CMD bash --login
