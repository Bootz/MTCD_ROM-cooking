# cd to dir so ls -d is working

umount $WORKDIR/mount_path/

# mounting image
echo
echo "mounting oem.img"
mount $WORKDIR/working/dupdate.img.dump/Image/oem.img $WORKDIR/mount_path >> $LOGFILE 2>&1


cd $WORKDIR/mount_path/apk/preinstall

pkglist=""
n=1
for pkg in $(ls -d *)
do
        pkglist="$pkglist $pkg $n off"
        n=$[n+1]
done

cd $WORKDIR

choices=`/usr/bin/dialog --stdout --checklist 'Choose APKs you want to REMOVE from being preinstalled after first launch e.g. Acrobat Reader:' 80 80 80 $pkglist`


if [ $? -eq 0 ]
then
        for choice in $choices
        do
                TEMP="$TEMP $choice"
        done
else
        exit
fi



dialog --title "Remove unwanted preinstallation APKs" \--yesno "Are you sure you want to remove \n $TEMP ?" 7 60

response=$?
case $response in
   0) echo "Deleting selected APKs"

        for choice in $choices
        do
                echo "Removing OEM $choice" >> $LOGFILE 2>&1
                rm -rf $WORKDIR/mount_path/apk/preinstall/$choice >> $LOGFILE 2>&1
        done
	;;

   1)   ;;
	#functClean & exit;;

   255)  ;;
	#functClean & exit;;
esac

unset choices
unset response
unset TEMP 
