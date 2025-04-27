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
targetMAC = 2C:CF:67:9D:BA:66
# ------------------------------------------------------------- #

## INSTALL DEPENDENCIES
sudo apt install bluetooth screen

## 
sudo rfcomm -i hci0 bind /dev/rfcomm0 $targetMAC 22
sudo screen /dev/rfcomm0