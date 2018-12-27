### Full build script for OpenCV with/without cuda support on conda environment.

Change path in install.sh according to your needs.

#### Install cuda and cudnn using [link](https://stackoverflow.com/a/47503155/6761181)

#### Install anaconda using [link](https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-16-04)

#### Create python environment  in anaconda and activate it using:

`conda create -n py python=3.5 anaconda`
`source activate py`

#### Change permission of install.sh:

`chmod +x install.sh`

#### Build opencv by running script file with path(where downloading of Opencv and other repos will take place) like:

`./install.sh /home/ai/Documents/vineet/download/`

#### Find compiled opencv :-

`sudo find / -type f -name "cv2.cpython-35m-x86_64-linux-gnu.so"`
Note:- use your compiled file name above.

#### Copy complied opencv module into your conda environment python3.5/site-packages

`cp cv2.cpython-35m-x86_64-linux-gnu.so /home/ai/anaconda3/envs/py/lib/python3.5/site-packages/`
Note:- After going into founded directory run above command. It will move above founded file into your environment python library site-packages.
  
#### Environment used for testing above code is:

Opencv:- 4.0.1
Ubuntu 16.04,
Nvidia driver- 384.130,
GPU: GTX 1070,
Cuda9 with cudnn support
