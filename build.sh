#!/bin/sh

zip -r -o -X -ll box_lite_$(cat module.prop | grep 'version=' | awk -F '=' '{print $2}').zip ./ -x '.git/*' -x 'build.sh' -x '.github/*' -x 'update.json'
