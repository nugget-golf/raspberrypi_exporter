#!/bin/bash

# check if run as superuser
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/nugget-golf/raspberrypi_exporter/master/uninstaller.sh)"

[ -d "/var/lib/node_exporter" ] || mkdir -p "/var/lib/node_exporter"

systemctl stop raspberrypi_exporter.timer
systemctl disable raspberrypi_exporter.timer

curl -s -L "https://raw.githubusercontent.com/nugget-golf/raspberrypi_exporter/master/raspberrypi_exporter" --output "/usr/local/bin/raspberrypi_exporter"
chmod +x /usr/local/bin/raspberrypi_exporter

curl -s -L "https://raw.githubusercontent.com/nugget-golf/raspberrypi_exporter/master/raspberrypi_exporter.service" --output "/etc/systemd/system/raspberrypi_exporter.service"
curl -s -L "https://raw.githubusercontent.com/nugget-golf/raspberrypi_exporter/master/raspberrypi_exporter.timer" --output "/etc/systemd/system/raspberrypi_exporter.timer"

systemctl daemon-reload
systemctl enable raspberrypi_exporter.timer
systemctl start raspberrypi_exporter.timer
