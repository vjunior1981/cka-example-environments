#!/bin/bash
echo
echo
echo "[*] Running update-dns.sh"
echo


sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf
service systemd-resolved restart
