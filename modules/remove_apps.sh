# cd to dir so ls -d is working
cd $WORKDIR/mount_path/app

pkglist=""
n=1
for pkg in $(ls -d *)
do
        pkglist="$pkglist $pkg $n off"
        n=$[n+1]
done

cd $WORKDIR

choices=`/usr/bin/dialog --stdout --checklist 'Choose APKs you want to REMOVE:' 80 80 80 $pkglist`


if [ $? -eq 0 ]
then
        for choice in $choices
        do
                TEMP="$TEMP $choice"
        done
else
        functClean
        exit
fi



dialog --title "Remove unwanted APKs" \--yesno "Are you sure you want to remove \n $TEMP ?" 7 60

response=$?
case $response in
   0) echo "Deleting selected APKs"

        for choice in $choices
        do
                echo "Removing $choice" >> $LOGFILE 2>&1
                rm -rf $WORKDIR/mount_path/app/$choice >> $LOGFILE 2>&1
        done
	;;

   1) functClean & exit;;

   255) functClean & exit;;
esac

unset choices
unset response
unset TEMP 
