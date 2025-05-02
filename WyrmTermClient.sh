#!/bin/bash

# =========================================== WyrmTerm ========================================== #
#
# Script Name:  WyrmTermClient
# Description:  Launches a terminal emulator bound to a Bluetooth serial connection for remote
#               access to a target device using Getty authentication. Run 'WyrmTermTarget' on the
#               target device first.
# Author:       Richard "RogueFlotilla" Flores
# Created:      2025-04-17
# Modified:     2025-05-01
# Version:      dev-2025-05-01
# Usage:        sudo ./WyrmTermClient
# Dependencies: bluetooth, bluez, coreutils, screen
# Tested on:    Debian 12.10, BlueZ 5.66, Bash 5.2.15-2+b7, Screen 4.9.0-4
# License:      Currently for academic use only. Contact author for other use cases.
# Notes:        Developed while attending Marymount University, CAE-CD, Arlington, VA, for the
#               class IT 489 Capstone Project. Project title: Offline AI Reconnaissance and
#               Hacking Tool. Team Members: Richard Flores, Natasha Menon, and Charles "Matt" Penn.
# Known Issue:  Upon connection, the client may send unsolicited 'AT' commands to the target. This
#               occurs because the Bluetooth stack treats the connection as a modem link. It does
#               not block login, but users should wait for approximately three failed 'AT'
#               attempts before entering credentials. A workaround has not yet been identified.
#
# =============================================================================================== #

# ------------------------------------------ VARIABLES ------------------------------------------ #
# Configure variables here for setup
targetMAC="2C:CF:67:9D:BA:66" # MAC address of the Linux device being connected to
# Matt's Pi: "2C:CF:67:70:A6:5F" {OR} Richard's Pi: "2C:CF:67:9D:BA:66"
BThci="hci0" # Host Controller Interface of the Bluetooth adapter. TIP: command: "hciconfig -a".
BTchannel="30" # The Bluetooth channel (0-39) to use for the connection.
RFcomm="rfcomm0" # The virtual serial port created for the Bluetooth connection

# ----------------------------------------------------------------------------------------------- #

## INSTALL DEPENDENCIES
apt update
apt install bluetooth bluez coreutils screen

## ENSURE BLUETOOTH IS ON, ENABLED, AND CONFIGURED
systemctl enable bluetooth
systemctl start bluetooth
bluetoothctl -- power on
bluetoothctl -- agent on
bluetoothctl -- default-agent
bluetoothctl -- pairable on

## RELEASE PREVIOUS RFCOMM BIND
rfcomm release $BThci

## BIND BLUETOOTH SERIAL CONNECTION TO SCREEN FOR TERMINAL LOGIN
sudo rfcomm -i $BThci bind /dev/$RFcomm $targetMAC $BTchannel

## INITIATE REMOTE CONNECTION TO TARGET OVER BLUETOOTH SERIAL CONNECTION
sudo screen /dev/$RFcomm
