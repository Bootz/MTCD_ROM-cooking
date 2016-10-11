#!/bin/bash
# check if already a ROM is in place. Download JY ROM from Google Drive

        dialog --title "build.prop optimization" \--yesno "Do you want to add build.prop optimizations? This includes mainly stuff for dalvik engine." 7 60

        response=$?
        case $response in
        0) 
		echo "patching build.prop ..."
		# remove all dalvik entries to readd them tuned
		sed -i 's/.*dalvik.*//' $WORKDIR/mount_path/build.prop
		# adding modifications
		cat $WORKDIR/addons_other/build.prop_config >> $WORKDIR/mount_path/build.prop
        ;;
        1) ;;

        255) ;;
        esac
