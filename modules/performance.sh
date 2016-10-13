#!/bin/bash
# check if already a ROM is in place. Download JY ROM from Google Drive

        dialog --title "Optimizations" \--yesno "Do you want to add build.prop and other optimizations? This includes mainly stuff for dalvik engine." 7 60

        response=$?
        case $response in
        0) 
		echo "patching build.prop ..."
		# remove all dalvik entries to readd them tuned
		sed -i 's/.*dalvik.*//' $WORKDIR/mount_path/build.prop >> $LOGFILE 2>&1
		# adding modifications
		cat $WORKDIR/addons_other/build.prop_config >> $WORKDIR/mount_path/build.prop 
		
		# tune governors
		sed -i "/write \/sys\/fs\/cgroup\/memory\/sw\/memory.move_charge_at_immigrate.*/r $WORKDIR/addons_other/init.rc.patch" $WORKDIR/working/dupdate.img.dump/Image/boot.img.dump/init.rc >> $LOGFILE 2>&1

        ;;
        1) ;;

        255) ;;
        esac

unset response
