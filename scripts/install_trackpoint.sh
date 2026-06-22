#!/usr/bin/env bash
set -euo pipefail

ACCEL=-0.4

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../trackpoint" && pwd)"

sudo install -m 0755 "$SRC/trackpoint-tune.sh"      /usr/local/bin/trackpoint-tune.sh
sudo install -m 0644 "$SRC/trackpoint-tune.service" /etc/systemd/system/trackpoint-tune.service
sudo install -m 0755 "$SRC/trackpoint-sleep-hook"   /usr/lib/systemd/system-sleep/trackpoint

sudo systemctl daemon-reload
sudo systemctl enable --now trackpoint-tune.service

gsettings set org.gnome.desktop.peripherals.mouse speed "$ACCEL"
