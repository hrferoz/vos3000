#!/bin/bash
#中文-UTF8
yum remove -y kernel kernel-firmware
yum install -y kernel-2.6.32-358.el6.x86_64.rpm kernel-firmware-2.6.32-358.el6.noarch.rpm
reboot
echo "done"