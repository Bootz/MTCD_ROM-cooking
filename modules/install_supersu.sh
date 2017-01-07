dialog --title "ROOT" \--yesno "Do you want to root the ROM by including SuperSU? :-) " 7 60

response=$?
case $response in
0)
		echo "rooting ROM ..."


		SUPATH=$WORKDIR/addons_other/SuperSU/armv7
		COMPATH=$WORKDIR/addons_other/SuperSU/common

		function copy_chmod
		{
				# source target chmod
				cp -a $1 $2 >> $LOGFILE 2>&1
				chmod $3 $2 >> $LOGFILE 2>&1
		}


		# install apk
		mkdir $WORKDIR/mount_path/app/Superuser
		copy_chmod $COMPATH/Superuser.apk $WORKDIR/mount_path/app/Superuser/ 0644
		chmod 0755 $WORKDIR/mount_path/app/Superuser

		# other stuff
		mkdir $WORKDIR/mount_path/bin/.ext >> $LOGFILE 2>&1
		chmod 0777 $WORKDIR/mount_path/bin/.ext >> $LOGFILE 2>&1
		copy_chmod $SUPATH/su $WORKDIR/mount_path/bin/.ext/.su 0755
		copy_chmod $SUPATH/su $WORKDIR/mount_path/xbin/su 0755
		copy_chmod $SUPATH/su $WORKDIR/mount_path/xbin/daemonsu 0755
		copy_chmod $COMPATH/install-recovery.sh $WORKDIR/mount_path/etc/install-recovery.sh 0755
		ln -s -r $WORKDIR/mount_path/etc/install-recovery.sh $WORKDIR/mount_path/bin/install-recovery.sh >> $LOGFILE 2>&1
		copy_chmod $SUPATH/supolicy $WORKDIR/mount_path/xbin/supolicy 0755
		copy_chmod $SUPATH/libsupol.so $WORKDIR/mount_path/lib/libsupol.so 0755
		cp -a $WORKDIR/mount_path/bin/app_process32 $WORKDIR/mount_path/bin/app_process32_original >> $LOGFILE 2>&1
		cp -a $WORKDIR/mount_path/bin/app_process32 $WORKDIR/mount_path/bin/app_process_init >> $LOGFILE 2>&1
		rm -f $WORKDIR/mount_path/bin/app_process32 >> $LOGFILE 2>&1
		rm -f $WORKDIR/mount_path/bin/app_process >> $LOGFILE 2>&1
		ln -s -r $WORKDIR/mount_path/xbin/daemonsu $WORKDIR/mount_path/bin/app_process >> $LOGFILE 2>&1
		ln -s -r $WORKDIR/mount_path/xbin/daemonsu $WORKDIR/mount_path/bin/app_process32 >> $LOGFILE 2>&1
		mkdir $WORKDIR/mount_path/etc/init.d >> $LOGFILE 2>&1
		copy_chmod $COMPATH/99SuperSUDaemon $WORKDIR/mount_path/etc/init.d/99SuperSUDaemon 0755
		echo 1 > $WORKDIR/mount_path/etc/.installed_su_daemon
		chmod 0644 $WORKDIR/mount_path/etc/.installed_su_daemon >> $LOGFILE 2>&1

		# update busybox
		#rm -f $WORKDIR/mount_path/bin/busybox* >> $LOGFILE 2>&1
		#cp $WORKDIR/addons_other/busybox $WORKDIR/mount_path/bin >> $LOGFILE 2>&1
		#chmod 0755 $WORKDIR/mount_path/bin/busybox >> $LOGFILE 2>&1

;;
1) ;;

255) ;;
esac

unset response
