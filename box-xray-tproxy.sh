#!/system/bin/sh
scripts_dir="/data/adb/box-xray-tproxy/scripts"
(until [ "$(getprop sys.boot_completed)" -eq 1 ]; do sleep 5; done; "${scripts_dir}/start.sh") &
