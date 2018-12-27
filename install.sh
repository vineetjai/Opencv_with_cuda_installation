#!/bin/bash
# Run: $ curl -fsSL http://bit.ly/OpenCV-Latest | [optirun] bash -s /path/to/download/folder
# Install libeigen3-dev: http://launchpadlibrarian.net/356350632/libeigen3-dev_3.3.4-4_all.deb
# Run: sudo ln -s /usr/lib/nvidia-387/libnvcuvid.so /usr/lib/libnvcuvid.so
# Run: sudo ln -s /usr/lib/nvidia-387/libnvcuvid.so.1 /usr/lib/libnvcuvid.so.1
set -e
RESET='\033[0m'
COLOR='\033[1;32m'

function msg {
  echo -e "${COLOR}$(date): $1${RESET}"
}

function fail {
  msg "Error : $?"
  exit 1
}

function mcd {
  mkdir -p "$1" || fail
  cd "$1" || fail
}

if [ -z "$1" ]; then
  msg "No Download Path Specified"
fi

# Script
msg "Installation Started"

DOWNLOAD_PATH=$1
msg "OpenCV will be downloaded in $DOWNLOAD_PATH"

msg "Updating system before installing new packages."
sudo add-apt-repository -y ppa:jonathonf/ffmpeg-3 || fail
sudo apt -y update || fail
sudo apt -y upgrade || fail
sudo apt -y dist-upgrade || fail
sudo apt -y autoremove || fail
sudo apt -y autoclean || fail

msg "Installing build tools."
sudo apt install -y                                                           \
  build-essential                                                             \
  cmake                                                                       \
  git                                                                         \
|| fail

msg "Installing GUI components."
sudo apt install -y                                                           \
  libharfbuzz-dev                                                             \
  libvtk6-dev                                                                 \
  python-vtk6                                                                 \
  qt5-default                                                                 \
|| fail

msg "Installing media I/O componenets."
sudo apt install -y                                                           \
  libavresample-dev                                                           \
  libgdal-dev                                                                 \
  libgphoto2-dev                                                              \
  libjasper-dev                                                               \
  libjpeg-dev                                                                 \
  libopenexr-dev                                                              \
  libpng-dev                                                                  \
  libtiff5-dev                                                                \
  libwebp-dev                                                                 \
  zlib1g-dev                                                                  \
|| fail

msg "Installing video I/O components."
sudo apt install -y                                                           \
  libavcodec-dev                                                              \
  libavformat-dev                                                             \
  libdc1394-22-dev                                                            \
  libopencore-amrnb-dev                                                       \
  libopencore-amrwb-dev                                                       \
  libswscale-dev                                                              \
  libtheora-dev                                                               \
  libv4l-dev                                                                  \
  libvorbis-dev                                                               \
  libx264-dev                                                                 \
  libxine2                                                                    \
  libxine2-dev                                                                \
  libxvidcore-dev                                                             \
  yasm                                                                        \
|| fail

msg "Installing Streaming Components."
sudo apt install -y                                                           \
  gstreamer1.0-doc                                                            \
  gstreamer1.0-libav                                                          \
  gstreamer1.0-plugins-bad                                                    \
  gstreamer1.0-plugins-base                                                   \
  gstreamer1.0-plugins-good                                                   \
  gstreamer1.0-plugins-ugly                                                   \
  gstreamer1.0-tools                                                          \
  libgstreamer1.0-0                                                           \
  libgstreamer1.0-dev                                                         \
  libgstreamer-plugins-bad1.0-dev                                             \
  libgstreamer-plugins-base1.0-dev                                            \
  libgstreamer-plugins-good1.0-dev                                            \
|| fail

msg "Installing Linear Algebra and Parallelism libs."
sudo apt install -y                                                           \
  libboost-all-dev                                                            \
  libfftw3-dev                                                                \
  libfftw3-mpi-dev                                                            \
  libmpfr-dev                                                                 \
  libopenblas-dev                                                             \
  libsuperlu-dev                                                              \
  libtbb-dev                                                                  \
|| fail


msg "Installing LAPACKE libs."
sudo apt install -y                                                           \
  checkinstall                                                                \
  liblapacke-dev                                                              \
|| fail

msg "Installing SFM components."
sudo apt install -y                                                           \
  libatlas-base-dev                                                           \
  libgflags-dev                                                               \
  libgoogle-glog-dev                                                          \
  libsuitesparse-dev                                                          \
|| fail

msg "Installing Python."
sudo apt install -y                                                           \
  pylint                                                                      \
  python-dev                                                                  \
  python-numpy                                                                \
  python-tk                                                                   \
  python3-dev                                                                 \
  python3-numpy                                                               \
  python3-tk                                                                  \
|| fail

msg "Installing JDK."
sudo apt install -y                                                           \
  ant                                                                         \
  default-jdk                                                                 \
|| fail

msg "Installing Docs."
sudo apt install -y doxygen || fail

msg "All deps installed. Continuing with installation"

# Downloading
cd $DOWNLOAD_PATH

REPOS="ceres-solver,https://ceres-solver.googlesource.com/ceres-solver
  opencv,https://github.com/opencv/opencv.git
  opencv_contrib,https://github.com/opencv/opencv_contrib.git
  opencv_extra,https://github.com/opencv/opencv_extra.git"

for repo in $REPOS; do
  IFS=","
  set $repo
  if [[ -D$1 && -x $1 ]]; then
    msg "Updating $1 Repo."
    cd $1
    git pull || fail
    cd ..
  else
    msg "Downloading $1 Package"
    git clone $2 || fail
  fi
done

msg "Configuring Ceres Solver."
mcd ceres-solver/build
cmake \
  -DCMAKE_C_FLAGS="-fPIC"                                                     \
  -DCMAKE_CXX_FLAGS="-fPIC"                                                   \
  -DBUILD_EXAMPLES=OFF                                                        \
  -DBUILD_SHARED_LIBS=ON                                                      \
.. || fail

msg "Making Ceres Solver."
make -j $(($(nproc)+1)) || fail
make -j $(($(nproc)+1)) test || fail
msg "Installing Ceres Solver."

sudo make -j $(($(nproc)+1)) install || fail
cd $DOWNLOAD_PATH

sudo rm -rf opencv/build || fail
mcd opencv/build || fail


# Uninstalling and installing below package to remove any error in build
sudo apt-get autoremove libtiff5-dev
sudo apt-get install libtiff5-dev

# Configuring make
msg "Configuring OpenCV Make"

cmake \
-DCMAKE_BUILD_TYPE=RELEASE                                                                  \
-DCMAKE_INSTALL_PREFIX=/home/ai/Documents/vineet/opencv-install/                            \
-DINSTALL_PYTHON_EXAMPLES=ON                                                                \
-DINSTALL_C_EXAMPLES=OFF                                                                    \
-DOPENCV_EXTRA_MODULES_PATH=/home/ai/Documents/vineet/download/opencv_contrib/modules/      \
-DPYTHON_EXECUTABLE=/home/ai/anaconda3/envs/py/bin/python3.5                                \
-DCUDA_LIBRARY=/home/ai/Documents/vineet/cuda/lib64/stubs/libcuda.so                        \
-DCUDA_FAST_MATH=ON                                                                         \
-DWITH_CUDA=ON                                                                              \
-DWITH_CUBLAS=ON                                                                            \
-DCUDA_TOOLKIT_ROOT_DIR=/home/ai/Documents/vineet/cuda/                                     \
-DBUILD_OPENCV_JAVA=OFF                                                                     \
-DWITH_TBB=ON                                                                               \
-DWITH_V4L=ON                                                                               \
-DWITH_QT=ON                                                                                \
-DWITH_OPENGL=ON                                                                            \
-DBUILD_LIBPROTOBUF_FROM_SOURCES=ON                                                         \
.. || fail

# Making
msg "Building OpenCV."
make -j $(($(nproc)+1)) || fail
make -j $(($(nproc)+1)) test || fail

# msg "Installing OpenCV"
# sudo make -j $(($(nproc)+1)) install || fail
# sudo ldconfig || fail

# Finished
# msg "Installation finished for OpenCV"
msg "Copy your opencv compiled file into dist-packages of environment"
