#!/bin/bash

echo 'FQDN:'
hostname -f

echo 'Host Information:'
hostnamectl

echo 'IP address:'
hostname -I

echo 'Space Available:'
df / -h

