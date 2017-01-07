dialog --title "ROOT" \--yesno "Do you want to set the performance CPU governor at boot?" 7 60

response=$?
case $response in
0)
		echo "creating bootscript..."

		function copy_chmod
		{
				# source target chmod
				cp -a $1 $2 >> $LOGFILE 2>&1
				chmod $3 $2 >> $LOGFILE 2>&1
		}

      #make sure init.d exists
		mkdir -p $WORKDIR/mount_path/etc/init.d >> $LOGFILE 2>&1

      #rm file if it exists
      rm -f $WORKDIR/mount_path/etc/init.d/99SetGov

      #build the new init script
      echo '#''!'"/system/bin/sh" > $WORKDIR/mount_path/etc/init.d/99SetGovernor
      echo "echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor" >> $WORKDIR/mount_path/etc/init.d/99SetGovernor

      chmod $WORKDIR/mount_path/etc/init.d/99SetGovernor 0755
;;
1) ;;

255) ;;
esac

unset response
