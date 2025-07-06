#!/bin/bash
#-------------------------------------------------------------------------------
#   Copyright (c) 2022 DOIDO Technologies.
#   Version  : 1.0.1
#   Location : github
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
# This script installs all requirements needed for ST7735 LCD
#-------------------------------------------------------------------------------

echo " "
echo "Installing packages required for the library to work..."
echo " "
sudo apt update
sudo apt install -y build-essential python3-dev python3-smbus python3-pip python3-pil python3-numpy
sudo apt install -y python3-rpi.gpio python3-spidev

echo " "
echo "Installing Raspberry Pi GPIO and Adafruit GPIO libraries for Python..."
echo " "
sudo python3 -m pip install --break-system-packages RPi.GPIO
sudo python3 -m pip install --break-system-packages Adafruit_GPIO
sudo python3 -m pip install --break-system-packages psutil
sudo python3 -m pip install --break-system-packages --upgrade certifi
sudo pip3 install --break-system-packages requests
sudo pip3 install --break-system-packages "requests[socks]"
sudo pip3 install --break-system-packages pysocks

echo " "
echo "Cloning and installing the LCD library..."
echo " "
git clone https://github.com/doido-technologies/st7735-python.git
cd st7735-python/library
sudo python3 setup.py install

echo " "
echo "Enabling SPI port..."
echo " "
sudo sed -i 's/dtparam=spi=off/dtparam=spi=on/g' /boot/config.txt
sudo sed -i 's/#dtparam=spi=on/dtparam=spi=on/g' /boot/config.txt

echo " "
echo "Setup complete!"
echo " "
