# hardware_design
This repository contains the design file associated with the hardware

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