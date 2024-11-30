#!/system/bin/sh

SKIPUNZIP=1
ASH_STANDALONE=1
unzip_path="/data/adb"

# Define the paths of source folder and the destination folder
source_folder="/data/adb/box_tproxy"
destination_folder="/data/adb/box_tproxy$(date +%Y%m%d_%H%M%S)"

# Check if the source folder exists
if [ -d "$source_folder" ]; then
    # If the source folder exists, execute the move operation
    mv "$source_folder" "$destination_folder"
    ui_print "- 正在备份已有文件"
    # Delete old folders and update them
    rm -rf "$source_folder"
else
    # If the source folder does not exist, output initial installation information 
    ui_print "- 正在初始安装"
fi

ui_print "- 正在释放文件"
unzip -o "$ZIPFILE" 'box_tproxy/*' -d $unzip_path >&2
unzip -j -o "$ZIPFILE" 'box-xray-tproxy.sh' -d /data/adb/service.d >&2
unzip -j -o "$ZIPFILE" 'uninstall.sh' -d $MODPATH >&2
unzip -j -o "$ZIPFILE" "module.prop" -d $MODPATH >&2
ui_print "- 正在设置权限"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm_recursive /data/adb/box_tproxy/ 0 3005 0755 0644
set_perm_recursive /data/adb/box_tproxy/scripts/ 0 3005 0755 0700
set_perm /data/adb/service.d/box-xray-tproxy.sh 0 0 0755
set_perm $MODPATH/uninstall.sh 0 0 0755
set_perm /data/adb/box_tproxy/scripts/ 0 0 0755
ui_print "- 完成权限设置"
ui_print "- 还原配置文件"

# 找到文件夹对应的最大的数字
largest_folder=$(find /data/adb -maxdepth 1 -type d -name 'box_tproxy[0-9]*' | sed 's/.*box_tproxy//' | sed 's/_//g' | sort -nr | head -n 1)

# 使用这个最大的数字，重新匹配回原始文件夹名
if [ -n "$largest_folder" ]; then
  for folder in /data/adb/box_tproxy*; do
    clean_name=$(echo "$folder" | sed 's/.*box_tproxy//' | sed 's/_//g')
    if [ "$clean_name" = "$largest_folder" ]; then
      ui_print "- Found folder: $folder"
      
      # 覆盖 /data/adb/box_tproxy/confs 目录中的内容
      if [ -d "$folder/confs" ]; then
        cp -rf "$folder/confs/"* /data/adb/box_tproxy/confs/
        cp -f "$folder/scripts/settings.ini" /data/adb/box_tproxy/scripts/
        ui_print "- Copied contents of $folder/confs to /data/adb/box_tproxy/confs/"
        cp -rf "$folder/xray/"* /data/adb/box_tproxy/xray/
        ui_print "- Copied contents of $folder/xray to /data/adb/box_tproxy/xray/"        
        ui_print "- 成功还原节点配置文件"
        ui_print "- 成功还原settings.ini"
        ui_print "- 成功还原xray配置文件"
      fi
      break
    fi
  done
else
  ui_print "- 首次安装，无备份配置可还原"
fi

ui_print "- enjoy!"
