# Hardware Design
This repository contains the design files associated with the hardware mallet holder.

## Hardware Model Design
[OpenSCAD](https://openscad.org/) was used for the design of the 3D printable models.

### Two Mallet Designs

double_mallet_servo -> (legacy) first (non UR5) version
double_mallet_servo_compliant_full -> (legacy) first version with flex model for urdf
double_mallet_servo_UR5 -> ur5 top
double_mallet_servo_UR5_battery -> battery holder added

attachments
static_mallet_attachment -> no rubber band based compliance
double_flex_v2_collision -> (legacy)
double_flex_v2 -> used flexible module with rubber bands

### One Mallet Designs

double_flex_v1 -> first rubber band two direction flexible version
rigid_base_version -> one mallet final version
v1 -> first rubber band one direction compliance
v2 -> enhanced version of v1

## Firmware
The firmware is implemented using the [Arduino](https://www.arduino.cc/) framework.
A [Raspberry Pi Pico W](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) is used as the controller of the device.

### Protocol
The protocol used for the communication between ROS and the microcontroller is based on simple string commands. For both the wifi and serial version the same protocol is used.

At first the ROS side is expected to request the bounds and resolution using the "l" command.
This allows for multiple devices with different bound to be used interchangeably though it could also be realized with config parameters on the ROS side.

The "p" command is used in the read phase of the hardware_interface (See [marimbabot_hardware](https://github.com/UHHRobotics22-23/marimbabot/tree/main/marimbabot_hardware)).

Lastly the "s" command allows the ROS side to give a integer valued command position to the microcontroller.

| Command           | Response                               | Command Description                             | Response Description                                                                                     |
|-------------------|----------------------------------------|-------------------------------------------------|----------------------------------------------------------------------------------------------------------|
| s \<value>        | ok, err_input_num, err_input_range     | Commands the servo to move to the value <value> | Errors for invalid number formats or numbers out of range of the safety limits or ok for acknowledgement |
| p                 | p \<value>                             | Requests the current target value               | Returns the current target value <value>                                                                 |
| l                 | l <min_val> <max_val> <val_resolution> | Requests the limits of the device               | Return the max and min value bounds and the resolution of the value parameter (0-res)                    |
| <invalid_command> | err_cmd                                | Any command other than the listed ones          | Error code for and invalid / unknown command                                                             |

### Flavours
Two firmwares were written as a part of the development process.
First one using a usb serial connection and secondly one using a wifi network created by the microcontroller.

Both firmwares feature the min and max value at the top of the file.
These are the max and min angle the servo can safely be set to and depends on the real world alignment of the servo and the 3d print.
The values for each device are found in a manual testing project by sending manual "s" commands.
The resolution for both is set to 180 as the servo can cover 180°
Alternatively the resolution could be increased by using direct the [pwm millisecond control mode](https://www.arduino.cc/reference/en/libraries/servo/writemicroseconds/).

#### Wifi
The wifi firmware is found in the [mallet_play_servo_wifi](arduino_code/mallet_play_servo_wifi/mallet_play_servo_wifi.ino) project.

The SSID and the password of the generated network can be set at the top of the file and needs reflashing.
Further the port of the UDP server can be adjusted inside of the setup function.

#### Serial
The serial firmware is found in the [mallet_play_servo](arduino_code/mallet_play_servo/mallet_play_servo.ino) project.

In the serial firmware the update frequency can be adjusted by changing the delay at the end of the loop.
The baud rate can be adjusted in the setup function. A high baud rate is needed to minimize the communication overhead.

## Electronics Design

## Hardware Calibration
The hardware calibration scripts are found in the [hardware_calibration](hardware_calibration) folder. The calibration is done by using a Azure Kinect depth camera in combination of color separation to find the 3d position of the red tapes on the mallets. The 3d coordinates are used to find the distance between the elements.
A mathematical model of the two mallet assembly is then used to find the expected opening angle from the distance. This angle is then compared to the commanded angle.

### How to use
First install the python dependencies using the [requirements.txt](hardware_calibration/requirements.txt) found in the hardware_calibration folder.

#### Setup
Use the azure kinect depth camera and connect it to the computer. A top down orientation onto the two mallet assembly indicated the best results. Clean the space of other red elements or cover them (like the red cables on the assembly).
Connect the computer to the Wifi sent out by the mallet assembly (the scripts use the raw control commands).

#### Data Collection
Two scripts are used for the measurement process.

First start [hardware_calibration.py](hardware_calibration/hardware_calibration.py).
This script uses the depth camera to measure the distance of the red tapes on the mallet.
The results are logged into a timestamped csv file (f"calibration-{time.time()}.csv").

Secondly start the [calibration_process.py](hardware_calibration/calibration_process.py).
This will generate the control input to the mallet holder and log to timestamp of each command.
One full sweep is run.
The data it logged into a timestamped csv file (f"calibration_pos-{time()}.csv").

After the sweep stop both scripts.

#### Data Preparation
To prepare the results remove all distance measurements before the first command value.
The analysis expects a continuous numberization of the meassurements.
The measured distance file also warrants careful examinations as the depth camera seems to have a few areas with bad accuracy.

#### Data Analysis
The data is analyzed using the Jupyter notebook [analyse_results.ipynb](hardware_calibration/analyse_results.ipynb).
To add new measurements extend the range operator in the 5th cell and run the notebook.
Especially the last graph gives a result about the angular offset for each commanded angle.