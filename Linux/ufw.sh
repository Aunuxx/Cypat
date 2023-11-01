#!/bin/sh

# simple shell script for ufw hardening
# Frin

apt install ufw

systemctl start ufw

ufw enable

ufw default deny