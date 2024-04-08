#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update 
sudo NEEDRESTART_SUSPEND=1 apt-get upgrade -y
sudo apt-get update
sudo NEEDRESTART_SUSPEND=1 apt-get -y install git git python3-dev libffi-dev gcc libssl-dev python3-venv

sudo mkdir -p /etc/kolla
sudo chown ubuntu:ubuntu /etc/kolla
