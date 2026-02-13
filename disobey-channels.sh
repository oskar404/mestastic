#!/usr/bin/env bash
# Script to setup the Disobey 2026 channels to a device.
# More on the channels: https://disobey.fi/2026/meshtastic.html
set -o errexit
set -o nounset

PORT="${1:?error: add the serial port as argument (e.g. /dev/ttyUSB0)}"
pipenv install --quiet >/dev/null

set -x  # Enable command tracing

pipenv run meshtastic -s $PORT \
  --set device.node_info_broadcast_secs 10800 \
  --set telemetry.device_telemetry_enabled false \
  --set position.position_broadcast_smart_enabled false \
  --set position.fixed_position false \
  --remove-position
read -p "Check reboot. Press Enter to continue..."

pipenv run meshtastic -s $PORT \
  --set lora.use_preset true \
  --set lora.modem_preset SHORT_FAST
read -p "Check reboot. Press Enter to continue..."

pipenv run meshtastic -s $PORT \
  --set lora.ignore_mqtt true \
  --set lora.config_ok_to_mqtt false \
  --set device.role CLIENT \
  --set mqtt.enabled false
read -p "Check reboot. Press Enter to continue..."

pipenv run meshtastic -s $PORT --ch-index 0 \
  --ch-set name Disobey \
  --ch-set psk base64:ZXZlcnl0aGluZ2lzYm9yaw==  \
  --ch-set uplink_enabled false \
  --ch-set downlink_enabled false \
  --ch-set module_settings.position_precision 0
read -p "Check reboot. Press Enter to continue..."

pipenv run meshtastic -s $PORT --ch-index 1 \
  --ch-set name MeshChat \
  --ch-set psk base64:RElTT0JFWTIwMjYtTUVTSA== \
  --ch-set uplink_enabled false \
  --ch-set downlink_enabled false \
  --ch-set module_settings.position_precision 0
#read -p "Check reboot. Press Enter to continue..."

echo "DONE"
