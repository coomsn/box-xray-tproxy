#!/system/bin/sh
clear
scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})
module_dir="/data/adb/modules/box-xray-tproxy"
# Environment variable settings
export PATH="/data/adb/ap/bin:/data/adb/ksu/bin:/data/adb/magisk:$PATH"

start_inotifyd() {
  PIDs=($(busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "box-xray-tproxy.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
	  break
    fi
  done
  inotifyd "${scripts_dir}/box-xray-tproxy.inotify" "${module_dir}" >/dev/null 2>&1 &
}

start_inotifyd

# {version:2.1}

source ${scripts_dir}/box-xray-tproxy.service

if [ ! -f "${module_dir}/disable" ]; then
  log Info "Module Enabled"
else
  log Warn "Module Disabled"
fi
