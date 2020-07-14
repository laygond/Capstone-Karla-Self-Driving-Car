This is the project repo for the final project of the Udacity Self-Driving Car Nanodegree: Programming a Real Self-Driving Car: Carla. This project focuses on system integration using ROS. The ROS framework is set to either communicate with Carla or a [Unity Simulator](https://github.com/udacity/CarND-Capstone/releases). This repo uses [Udacity's CarND-Capstone repo](https://github.com/udacity/CarND-Capstone) as a base template and guidance.

## OS and ROS Installation 
Please use **one** of the two following installation options: "Native or Virtual"
### Native or Virtual Installation
Because ROS is used, you will need to use Ubuntu locally or through a VM to develop and test your project code. You may use

- [Ubuntu 14.04 Trusty Tahir](https://releases.ubuntu.com/trusty/) with [ROS Indigo](http://wiki.ros.org/indigo/Installation/Ubuntu)
- [Ubuntu 16.04 Xenial Xerus](https://releases.ubuntu.com/xenial/) with [ROS Kinetic](http://wiki.ros.org/kinetic/Installation/Ubuntu)

You are welcome to install everything manually or use this [pre-built (recommmended) OS image]() of Ubuntu with ROS and Dataspeed DBW already installed (warning: it is almost 5GB). Once the image has been downloaded, open terminal and navigate to directory containing the compressed image to execute `$ unzip Udacity_VM_Base_V1.0.0.zip`

In either way: manual or pre-built, if using [VirtualBox](https://www.virtualbox.org/wiki/Downloads) as your Virtual Machine:
- Open VirtualBox Application.
- Click File > Import Appliance..
- Click the folder icon on the right and navigate to your unzipped image (the .ovf file).
- Follow the prompts to import the image.
- Before getting your VM up and running, navigate to the VM settings by clicking on the icon in the VirtualBox Manager. In the "System" cateogory Look for tabs labeled "Motherboard" and "Processor." Use the following configuration as minimum:
  - 2 CPU
  - 2 GB system memory
  - 25 GB of free hard drive space
- From the VirtualBox Manager, select your VM and press start.

Upon your first boot you will be prompted to choose a keyboard layout of your choice. Once you select a keyboard you will not be prompted for this again. If you would like to change your option you can reset this feature by entering `udacity_reset` in a terminal of your choice and restarting the VM.

Once you are up and running, you might be asked to input a password to enter the VM. The password for the VM is `udacity-nd`

### Docker Installation
[Install Docker](https://docs.docker.com/engine/installation/)

Build the docker container
```bash
docker build . -t capstone
```

Run the docker file
```bash
docker run -p 4567:4567 -v $PWD:/capstone -v /tmp/log:/root/.ros/ --rm -it capstone
```

## Simulator

* Download the [Udacity Simulator](https://github.com/udacity/CarND-Capstone/releases).

The simulator has two test tracks:
- A highway test track with traffic lights
- A testing lot test track similar to where we will run Carla

the simulator displays vehicle velocity in units of mph. However, all values used within the project code are use the metric system (m or m/s), including current velocity data coming from the simulator.

To use the second test lot, you will need to update your code to specify a new set of waypoints. We'll discuss how to do this in a later lesson. Additionally, the first track has a toggle button for camera data. Many students have experienced latency when running the simulator together with a virtual machine, and leaving the camera data off as you develop the car's controllers will help with this issue.


Test Lot
The CarND-Capstone/ros/src/waypoint_loader/launch/waypoint_loader.launch file is set up to load the waypoints for the first track. To test using the second track, you will need to change

<param name="path" value="$(find styx)../../../data/wp_yaw_const.csv" />
to use the churchlot_with_cars.csv as follows:

<param name="path" value="$(find styx)../../../data/churchlot_with_cars.csv"/>
Note that the second track does not send any camera data.

### Port Forwarding
To set up port forwarding, please refer to the "uWebSocketIO Starter Guide" found in the classroom (see Extended Kalman Filter Project lesson).

### Usage

1. Clone the project repository
```bash
git clone https://github.com/udacity/CarND-Capstone.git
```

2. Install python dependencies
```bash
cd CarND-Capstone
pip install -r requirements.txt
```
3. Make and run styx
```bash
cd ros
catkin_make
source devel/setup.sh
roslaunch launch/styx.launch
```
4. Run the simulator

## System Architecture




### Real world testing
1. Download [training bag](https://s3-us-west-1.amazonaws.com/udacity-selfdrivingcar/traffic_light_bag_file.zip) that was recorded on the Udacity self-driving car.
2. Unzip the file
```bash
unzip traffic_light_bag_file.zip
```
3. Play the bag file
```bash
rosbag play -l traffic_light_bag_file/traffic_light_training.bag
```
4. Launch your project in site mode
```bash
cd CarND-Capstone/ros
roslaunch launch/site.launch
```
5. Confirm that traffic light detection works on real life images

### Other library/driver information
Outside of `requirements.txt`, here is information on other driver/library versions used in the simulator and Carla:

Specific to these libraries, the simulator grader and Carla use the following:

|        | Simulator | Carla  |
| :-----------: |:-------------:| :-----:|
| Nvidia driver | 384.130 | 384.130 |
| CUDA | 8.0.61 | 8.0.61 |
| cuDNN | 6.0.21 | 6.0.21 |
| TensorRT | N/A | N/A |
| OpenCV | 3.2.0-dev | 2.4.8 |
| OpenMP | N/A | N/A |

We are working on a fix to line up the OpenCV versions between the two.


Carla will navigate the test track using waypoint navigation which will be generated based on the upcoming obtacles and traffic lights.
each waypoint has an associatted target velocity.


Troubleshooting Tips
Keyboard Mappings: Use of certain keyboards can create issues unless the corresponding keyboard has been set in the VM. This is due to keyboard mappings. A frequent issue is special characters in passwords not being entered correctly when logging in. An example useage for VirtualBox is setting up an Italian keyboard. To do this, execute the following in a terminal localectl set-keymap it; localectl set-x11-keymap it.

roscore ip: If the host network interface has multiple addresses (ex: ipv6 enabled) roscore will fail since hostname -I returns multiple ip, resulting into a invalid URL. One solution to this is to replace this line in .bashrc, export ROS_IP=`echo $( hostname -I)' , with this export ROS_IP=$( hostname -I | awk '{print $1}').

------
The eventual purpose of this node is to publish a fixed number of waypoints ahead of the vehicle with the correct target velocities, depending on traffic lights and obstacles. The goal for the first version of the node should be simply to subscribe to the topics

/base_waypoints
/current_pose
and publish a list of waypoints to

/final_waypoints

Final waypoints which will be publishing to waypoint follower, a piece of code from autoware, runs at 30Hz so you can go as low as 30Hz with your ROS code.

Once messages are being published to /final_waypoints, the vehicle's waypoint follower will publish twist commands to the /twist_cmd topic. The goal for this part of the project is to implement the drive-by-wire node (dbw_node.py) which will subscribe to /twist_cmd and use various controllers to provide appropriate throttle, brake, and steering commands. These commands can then be published to the following topics:

/vehicle/throttle_cmd
/vehicle/brake_cmd
/vehicle/steering_cmd

Once the vehicle is able to process waypoints, generate steering and throttle commands, and traverse the course, it will also need stop for obstacles. Traffic lights are the first obstacle that we'll focus on.

The traffic light detection node (tl_detector.py) subscribes to four topics:

/base_waypoints provides the complete list of waypoints for the course.
/current_pose can be used to determine the vehicle's location.
/image_color which provides an image stream from the car's camera. These images are used to determine the color of upcoming traffic lights.
/vehicle/traffic_lights provides the (x, y, z) coordinates of all traffic lights.
The node should publish the index of the waypoint for nearest upcoming red light's stop line to a single topic:

/traffic_waypoint

Once traffic light detection is working properly, you can incorporate the traffic light data into your waypoint updater node. To do this, you will need to add a subscriber for the /traffic_waypoint topic and implement the traffic_cb callback for this subscriber.

------------------
Important:
dbw_node.py is currently set up to publish steering, throttle, and brake commands at 50hz. The DBW system on Carla expects messages at this frequency, and will disengage (reverting control back to the driver) if control messages are published at less than 10hz. This is a safety feature on the car intended to return control to the driver if the software system crashes. You are welcome to modify how the dbw_node.py code is structured, but please ensure that control commands are published at 50hz.

Additionally, although the simulator displays speed in mph, all units in the project code use the metric system, including the units of messages in the /current_velocity topic (which have linear velocity in m/s).

Finally, Carla has an automatic transmission, which means the car will roll forward if no brake and no throttle is applied. To prevent Carla from moving requires about 700 Nm of torque.

0.1 m/s is the lowest speed of the car

