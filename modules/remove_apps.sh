# cd to dir so ls -d is working
cd $WORKDIR/mount_path/app

blacklist=$WORKDIR/modules/appblacklist.txt
pkglist=""
n=1

for pkg in $(ls -d *)
do
   if grep -q $pkg "$blacklist"; then
      pkglist="$pkglist $pkg $n on"
   else
      pkglist="$pkglist $pkg $n off"
   fi

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
   esac
fi

unset choices
unset response
unset TEMP 
