# jetson_configuration
Configuring the Jetson Nano for my deep learning tutorial

## Usage:

- This bash script works only for jetpack 4.3, so make sure you use that version on your nano.
- Dowload this repo and change permissions to jetson_configuration.sh file by typing "sudo chmod +x jetson_configuration.sh".
- Run the script and give your user password, ./jetson_configuration.sh <youruserpassword>

##### This script will build all necessary wheel files and this takes time, so be prepared to wait several hours!

If you can't access your nano from the web interface, please check the file "/etc/xdg/autostart/jupyterlab.desktop" in your nano.

Make sure that --ip= string has your nano ip address.

To access the nano open a browser and type <yournanoipaddress>:8888, i.e. 192.168.0.25:8888 and give the same password you typed to launch the script
