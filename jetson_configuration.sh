#!/bin/sh

set -e

password=$1

cd ~

# upgrade and remove unnecessary libraries
echo $password | sudo -S apt update
echo $password | sudo -S apt upgrade -y
echo $password | sudo -S apt remove --purge libreoffice* -y
echo $password | sudo -S apt autoremove -y
echo $password | sudo -S apt install htop -y

# install necessary dependencies
echo $password | sudo -S apt-get install -y libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev libopenblas-base 
echo $password | sudo -S apt-get install -y libatlas-base-dev gfortran libfreetype6-dev build-essential
echo $password | sudo -S apt install -y python3-pip python3-dev python3-smbus cmake
echo $password | sudo -S pip3 install -U pip testresources setuptools
echo $password | sudo -S pip3 install flask
echo $password | sudo -S pip3 install -U numpy==1.18.3
echo $password | sudo -S pip3 install pillow==7.1.2
echo $password | sudo -S pip3 install matplotlib==3.2.1
echo $password | sudo -S pip3 install pandas==1.0.3
echo $password | sudo -S pip3 install scipy==1.4.1
echo $password | sudo -S pip3 install cython
echo $password | sudo -S pip3 install scikit-learn==0.22.0
echo $password | sudo -S pip3 install seaborn==0.10.1
echo $password | sudo -S pip3 install -U future mock h5py keras_preprocessing keras_applications gast enum34 futures protobuf grpcio 
echo $password | sudo -S pip3 install -U absl-py py-cpuinfo psutil portpicker six mock requests astor termcolor protobuf  wrapt google-pasta
echo $password | sudo -S apt-get install -y virtualenv

# install traitlets (master)
echo $password | sudo -S python3 -m pip install git+https://github.com/ipython/traitlets@master

# install jupyter lab
echo $password | sudo -S apt install -y nodejs npm
echo $password | sudo -S pip3 install -U jupyter jupyterlab
jupyter lab --generate-config

# set jupyter password
python3 -c "from notebook.auth.security import set_password; set_password('$password', '$HOME/.jupyter/jupyter_notebook_config.json')"

# create new environment with tensorflow 2
mkdir ~/TF2
python3 -m virtualenv -p python3 ~/TF2/venv --system-site-packages
source ~/TF2/venv/bin/activate
pip install -U --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow==2.1.0+nv20.03
python3 -m ipykernel install --user --name=TF2
deactivate

# create new environment with tensorflow 1
mkdir ~/TF1
python3 -m virtualenv -p python3 ~/TF1/venv --system-site-packages
source ~/TF1/venv/bin/activate
pip install -U --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow==1.15.2+nv20.03
python3 -m ipykernel install --user --name=TF1
deactivate

# create new environment with pytorch
mkdir ~/Torch
python3 -m virtualenv -p python3 ~/Torch/venv --system-site-packages
source ~/Torch/venv/bin/activate
wget https://nvidia.box.com/shared/static/ncgzus5o23uck9i5oth2n8n06k340l6k.whl -O torch-1.4.0-cp36-cp36m-linux_aarch64.whl
pip install -U torch-1.4.0-cp36-cp36m-linux_aarch64.whl
pip install -U torchvision
rm torch-1.4.0-cp36-cp36m-linux_aarch64.whl
python3 -m ipykernel install --user --name=Torch
deactivate

# make swapfile
echo $password | sudo -S fallocate -l 4G /var/swapfile
echo $password | sudo -S chmod 600 /var/swapfile
echo $password | sudo -S mkswap /var/swapfile
echo $password | sudo -S swapon /var/swapfile
echo $password | sudo -S bash -c 'echo "/var/swapfile swap swap defaults 0 0" >> /etc/fstab'

# switch to lubuntu
echo $password | sudo -S apt remove --purge ubuntu-desktop -y
echo $password | sudo -S apt remove --purge gdm3 -y
echo $password | sudo -S apt install lxdm -y
echo $password | sudo -S apt install lxde -y
echo $password | sudo -S apt install --reinstall lxdm -y
echo $password | sudo -S sed -i "s|# autologin=dgod|autologin=$USER|g" /etc/lxdm/lxdm.conf

# start jupyter lab at sturtup
jetsonip=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(192.([0-9]*\.){2}[0-9]*).*/\2/p'`
echo $password | sudo -S bash -c "echo \"[Desktop Entry]\" >> /etc/xdg/autostart/jupyterlab.desktop"
echo $password | sudo -S bash -c "echo \"Name=jupyterlab\" >> /etc/xdg/autostart/jupyterlab.desktop"
echo $password | sudo -S bash -c "echo \"Exec=jupyter lab --ip=$jetsonip --no-browser --allow-root\" >> /etc/xdg/autostart/jupyterlab.desktop"

# add aliases for quick access
echo $password | sudo -S echo "alias tf2='source ~/TF2/venv/bin/activate'" >> /home/$USER/.bashrc
echo $password | sudo -S echo "alias tf1='source ~/TF1/venv/bin/activate'" >> /home/$USER/.bashrc
echo $password | sudo -S echo "alias torch='source ~/Torch/venv/bin/activate'" >> /home/$USER/.bashrc

# reboot the system
echo $password | sudo -S reboot
