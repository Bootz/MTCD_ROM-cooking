dialog --title "ROOT" \--yesno "Do you want to root the ROM by including SuperSU? :-) " 7 60

response=$?
case $response in
0)
		echo "rooting ROM ..."

		SUPATH=$WORKDIR/addons_other/SuperSU/armv7
		COMPATH=$WORKDIR/addons_other/SuperSU/common

		function copy_chmod_chcon
		{
				# source target chmod
				cp -a $1 $2 >> $LOGFILE 2>&1
				chmod $3 $2 >> $LOGFILE 2>&1
            setfattr -n security.selinux -v $4 $2 >> $LOGFILE 2>&1
            chown root:root $2 >> $LOGFILE 2>&1
		}

		# make directories we need
		mkdir -p $WORKDIR/mount_path/app/SuperSU >> $LOGFILE 2>&1
		chmod 0755 $WORKDIR/mount_path/app/SuperSU >> $LOGFILE 2>&1
      setfattr -n security.selinux -v u:object_r:system_file:s0 $WORKDIR/mount_path/app/SuperSU >> $LOGFILE 2>&1

		mkdir -p $WORKDIR/mount_path/etc/init.d >> $LOGFILE 2>&1
		chmod 0755 $WORKDIR/mount_path/etc/init.d >> $LOGFILE 2>&1
      setfattr -n security.selinux -v u:object_r:system_file:s0 $WORKDIR/mount_path/etc/init.d >> $LOGFILE 2>&1


      #now we will install root per SuperSU 'update-binary' script

      #superuser.apk renamed to SuperSU.apk in api 20+
		copy_chmod_chcon $COMPATH/Superuser.apk $WORKDIR/mount_path/app/SuperSU/SuperSU.apk 0644 u:object_r:system_file:s0

      #install-recovery.sh
		copy_chmod_chcon $COMPATH/install-recovery.sh $WORKDIR/mount_path/etc/install-recovery.sh 0755 u:object_r:toolbox_exec:s0
		ln -s -r $WORKDIR/mount_path/etc/install-recovery.sh $WORKDIR/mount_path/bin/install-recovery.sh >> $LOGFILE 2>&1

      #su binary
		copy_chmod_chcon $SUPATH/su $WORKDIR/mount_path/xbin/su 0755 u:object_r:system_file:s0
		copy_chmod_chcon $SUPATH/su $WORKDIR/mount_path/xbin/daemonsu 0755 u:object_r:system_file:s0

      #supolicy
		copy_chmod_chcon $SUPATH/supolicy $WORKDIR/mount_path/xbin/supolicy 0755 u:object_r:system_file:s0
		copy_chmod_chcon $SUPATH/libsupol.so $WORKDIR/mount_path/lib/libsupol.so 0644 u:object_r:system_file:s0

      #move original app_process32 to new name and install our new app_process32 which is symlinked to daemonsu
		copy_chmod_chcon -a $WORKDIR/mount_path/bin/app_process32 $WORKDIR/mount_path/bin/app_process32_original 0755 u:object_r:zygote_exec:s0
		copy_chmod_chcon -a $WORKDIR/mount_path/bin/app_process32 $WORKDIR/mount_path/bin/app_process_init 0755 u:object_r:zygote_exec:s0
		rm -f $WORKDIR/mount_path/bin/app_process32 >> $LOGFILE 2>&1
		rm -f $WORKDIR/mount_path/bin/app_process >> $LOGFILE 2>&1

      #symlink app_process --> daemonsu
		ln -s -r $WORKDIR/mount_path/xbin/daemonsu $WORKDIR/mount_path/bin/app_process >> $LOGFILE 2>&1
		ln -s -r $WORKDIR/mount_path/xbin/daemonsu $WORKDIR/mount_path/bin/app_process32 >> $LOGFILE 2>&1

      #create startup script
		copy_chmod_chcon $COMPATH/99SuperSUDaemon $WORKDIR/mount_path/etc/init.d/99SuperSUDaemon 0755 u:object_r:system_file:s0
      chown root:root $WORKDIR/mount_path/etc/init.d/99SuperSUDaemon

      #optional according to update-binary script
		echo 1 > $WORKDIR/mount_path/etc/.installed_su_daemon_temp
      copy_chmod_chcon $WORKDIR/mount_path/etc/.installed_su_daemon_temp $WORKDIR/mount_path/etc/.installed_su_daemon 0644 u:object_r:system_file:s0
      rm -f $WORKDIR/mount_path/etc/.installed_su_daemon_temp
;;
1) ;;

255) ;;
esac

unset response
