FROM public.ecr.aws/y8l1o1z1/ros2-jazzy:latest

USER root

RUN apt-get update
RUN apt-get install libserial-dev -y

# Using robot workspace
WORKDIR /home/user/robot_ws/src

# Clone Battery Level Broadcaster
RUN git clone https://github.com/netizen-robotics/battery_level_broadcaster

# Clone MC2048 Controller
RUN git clone https://github.com/netizen-robotics/mc2048-controller.git

WORKDIR /home/user/robot_ws
RUN rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/${ROS_DISTRO}/setup.sh && colcon build

# Setup entrypoint
COPY --chown=user:netizen_robotics ./script/entrypoint.sh  /home/user/entrypoint.sh
RUN chmod +x /home/user/entrypoint.sh

# Switch to user
USER user
WORKDIR /home/user
ENTRYPOINT ["/home/user/entrypoint.sh"]