FROM dlim04/baxter:base
LABEL maintainer="David Lim <dlim04@qub.ac.uk>" \
      description="A container-based development environment for working with Rethink Robotics Baxter robots."

USER root

# Install Packages
RUN apt-get -qq update && \
    apt-get -qq -y --no-install-recommends install \
      ros-indigo-desktop-full \
      x11vnc \
      xfce4 \
      xterm \
      xvfb \
      > /dev/null && \
      apt-get -qq clean

# Add baxter VNC startup script.
COPY files/start-vnc-server.sh /usr/local/bin/start-vnc-server.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash", "/usr/local/bin/start-vnc-server.sh"]
