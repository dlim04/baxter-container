#!/bin/bash -e

# Create ROS workspace
mkdir -p ~/ros_ws/src

# Install Baxter SDK
cd ~/ros_ws/src
wstool init .
wstool merge https://raw.githubusercontent.com/RethinkRobotics/baxter/master/baxter_sdk.rosinstall
wstool update

# Build Baxter SDK
source /opt/ros/indigo/setup.bash

cd ~/ros_ws
catkin_make
catkin_make install
