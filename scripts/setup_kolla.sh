#!/bin/bash

source ~/venv/bin/activate
cp -r ~/venv/share/kolla-ansible/etc_examples/kolla/* /etc/kolla
cp ~/venv/share/kolla-ansible/ansible/inventory/all-in-one ~/
kolla-ansible install-deps
kolla-genpwd
cp ~/globals.tmpl.yml /etc/kolla/globals.yml