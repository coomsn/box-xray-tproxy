#!/system/bin/sh
clear
echo "The process is starting, please wait"
scripts=$(realpath $0)
scripts_dir=$(dirname ${scripts})
parent_dir=$(dirname ${scripts_dir})
module_dir="/data/adb/modules/box_lite-module"

source ${scripts_dir}/box_lite.service

# environment variables
export PATH="/data/adb/magisk:/data/adb/ksu/bin:$PATH:/system/bin"

# Check if the disable file does not exist, then run the proxy
if [ ! -f "${module_dir}/disable" ]; then
  start_proxy # >/dev/null 2>&1
fi

start_box_lite.inotify() {
  PIDs=($(busybox pidof inotifyd))
  for PID in "${PIDs[@]}"; do
    if grep -q "box_lite.inotify" "/proc/$PID/cmdline"; then
      kill -9 "$PID"
    fi
  done
  inotifyd "${scripts_dir}/box_lite.inotify" "${module_dir}" >/dev/null 2>&1 &
}

start_box_lite.inotify