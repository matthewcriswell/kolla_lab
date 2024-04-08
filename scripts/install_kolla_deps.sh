#!/bin/bash

python3 -m venv ~/venv
source ~/venv/bin/activate
pip install -U pip
pip install 'ansible-core>=2.15,<2.16.99'
pip install git+https://opendev.org/openstack/kolla-ansible@master
