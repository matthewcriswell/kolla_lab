#!/bin/bash

source ~/venv/bin/activate
kolla-ansible -i ./all-in-one bootstrap-servers
kolla-ansible -i ./all-in-one prechecks
kolla-ansible -i ./all-in-one deploy


sudo usermod -aG docker $USER
pip install python-openstackclient -c https://releases.openstack.org/constraints/upper/master

kolla-ansible post-deploy