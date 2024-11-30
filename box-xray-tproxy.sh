#!/system/bin/sh

scripts_dir="/data/adb/box-xray-tproxy/scripts"
(
until [ "$(getprop sys.boot_completed)" -eq 1 ]; do
    sleep 4
done

chmod 755 "${scripts_dir}/start.sh"

"${scripts_dir}/start.sh" &
)