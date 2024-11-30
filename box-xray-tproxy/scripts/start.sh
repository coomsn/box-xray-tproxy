#!/system/bin/sh
clear
scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})
parent_dir=$(dirname ${scripts_dir})
module_dir="/data/adb/modules/box-xray-tproxy"

source ${scripts_dir}/box-xray-tproxy.service
log Info "The process is starting, please wait"

# Check if the disable file does not exist, then run the proxy
if [ ! -f "${module_dir}/disable" ]; then
  start_tproxy # >/dev/null 2>&1
fi

start_inotifyd() {
  PIDs=($(busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "box-xray-tproxy.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
    fi
  done
  inotifyd "${scripts_dir}/box-xray-tproxy.inotify" "${module_dir}" >/dev/null 2>&1 &
}

start_inotifyd
