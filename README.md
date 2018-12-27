### Full build script for OpenCV with/without cuda support on conda environment.

Change path in install.sh according to your needs.

#### Install cuda and cudnn using [link](https://stackoverflow.com/a/47503155/6761181)

#### Install anaconda using [link](https://www.digitalocean.com/community/tutorials/how-to-install-the-anaconda-python-distribution-on-ubuntu-16-04)

#### Create python environment  in anaconda and activate it using:

`conda create -n py python=3.5 anaconda`
`source activate py`

#### Change permission of install.sh:

`chmod +x install.sh`

#### Run script file with path(where downloading of Opencv and other repos will take place) like:

`./install.sh /home/ai/Documents/vineet/download/`

#### My environment is:

Ubuntu 16.04,
Nvidia driver- 384.130,
GPU: GTX 1070,
Cuda9 with cudnn support
