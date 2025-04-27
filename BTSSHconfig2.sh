#!/bin/bash

## PROJECT INFORMATION:
# Project Title: 
# Team Members: Richard Flores, Natasha Menon, and Matt Penn
# Class: IT 490 Capstone Project
# Submission Date: May 1, 2025

## DESCRIPTION:
# This code creates a terminal emulator connection on a remote host for a client device, such as a 
# tablet, to connect to it over a serial bluetooth connection using Getty authentication.

## NOTES:
# This script should be run with elevated privilleges (sudo). It was created to automate a tutorial 
# by "Yes, I know IT !" YouTube video tutorial on 'How to open a Linux Session over Bluetooth ? 
# Yes, I Know IT ! Ep 26' - https://www.youtube.com/watch?v=7xBSgb1GwCw.

# ------------------------- VARIABLES ------------------------- #
# Configure variables here for setup
tabletMAC = A8:CA:77:05:42:C1
# ------------------------------------------------------------- #

## UPDATE APT CACHE AND UPGRADE INSTALLATION
sudo apt update
# sudo apt upgrade -y

## INSTALL BLUETOOTH PACKAGE IN ORDER TO GET DEFAULT SERVICE FILE
sudo apt install bluetooth

## DISABLE DEFAULT BLUETOOTH SERVICE
sudo systemctl stop bluetooth
sudo systemctl disable bluetooth

## CREATE A NEW BLUETOOTH SERVICE BASED OFF DEFAULT ONE
sudo cp /lib/systemd/system/bluetooth.service /etc/systemd/system/

## CUSTOMIZE NEW BLUETOOTH SERVICE
# Run in compatibility mode
sudo sed -i "/ExecStart=/s/$/ --compat/" \
/etc/systemd/system/bluetooth.service

# enable page and inquiry scan
grep -qxF "ExecStartPost=/bin/hciconfig hci0 piscan" /etc/systemd/system/bluetooth.service || \
sudo sed -i "/ExecStart=/a \\
ExecStartPost=/bin/hciconfig hci0 piscan" \
/etc/systemd/system/bluetooth.service

# Power-up the first bluetooth controller
grep -qxF "ExecStartPost=/bin/hciconfig hci0 up" /etc/systemd/system/bluetooth.service || \
sudo sed -i "/ExecStart=/a \\
ExecStartPost=/bin/hciconfig hci0 up" \
/etc/systemd/system/bluetooth.service

# Advertise the port 22 of the bluetooth device as being a virtual serial port
grep -qxF "ExecStartPost=/usr/bin/sdptool add --channel=22 SP" /etc/systemd/system/bluetooth.service || \
sudo sed -i "/ExecStart=/a \\
ExecStartPost=/usr/bin/sdptool add --channel=22 SP" \
/etc/systemd/system/bluetooth.service

## CREATE SYMBOLIC LINKS TO NEW BLUETOOTH SERVICE FILE CREATED
sudo systemctl daemon-reload
sudo systemctl enable /etc/systemd/system/bluetooth.service

## START BLUETOOTH SERVICE
sudo systemctl start bluetooth.service

