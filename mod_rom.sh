#!/bin/bash
WORKDIR=$(pwd)
_temp="$WORKDIR/working/answer.$$"

function functClean
{
	echo "cleaning up..."
	echo
	if mountpoint -q $WORKDIR/mount_path 
	then
		echo "umounting image"
		umount $WORKDIR/mount_path
	fi
	echo "remove working files"
	rm -rf $WORKDIR/working/*
}


echo "creating working copy of ROM image"
cp -a $WORKDIR/orig_image/dupdate.img $WORKDIR/working/

echo "extracting image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img

echo 
echo "mounting system.img"
mount $WORKDIR/working/dupdate.img.dump/Image/system.img $WORKDIR/mount_path

if [!-d "$WORKDIR/mount_path/app"]; then
    echo "mounting failed! exiting...";
    functClean
    exit;
fi;

echo "done mounting"






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
		echo "Removing $choice"
		echo $WORKDIR/mount_path/app/$choice 
                rm -rf $WORKDIR/mount_path/app/$choice
        done
;;

   1) functClean & exit;;

   255) functClean & exit;;
esac


echo "patching build.prop ..."
# remove all dalvik entries to readd them tuned
sed -i 's/.*dalvik.*//' $WORKDIR/mount_path/build.prop
# adding modifications
cat $WORKDIR/addons/build.prop_config >> $WORKDIR/mount_path/build.prop




# choose time format

dialog --backtitle "Time format" \
  --radiolist "Select time format: " 15 40 15\
        1 MM-dd-yyyy  on\
        2 dd.MM.yyyy off \
        3 MM/dd/yyyy off \
        4 dd/MM/yyyy off 2>$_temp

menuitem=`cat $_temp`
rm $_temp

case "$menuitem" in
        1)
		sed -i 's/ro.com.android.dateformat.*/ro.com.android.dateformat=MM-dd-yyyy/' $WORKDIR/mount_path/build.prop
            	;;
        2)
		sed -i 's/ro.com.android.dateformat.*/ro.com.android.dateformat=dd.MM.yyyy/' $WORKDIR/mount_path/build.prop
        	;;
        3)
		sed -i 's/ro.com.android.dateformat.*/ro.com.android.dateformat=MM\/dd\/yyyy/' $WORKDIR/mount_path/build.prop
            	;;
        4)
		sed -i 's/ro.com.android.dateformat.*/ro.com.android.dateformat=dd\/MM\/yyyy/' $WORKDIR/mount_path/build.prop
            	;;
	*)	exit 1
esac


echo "creating final image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img.dump

echo "moving final image"
mv $WORKDIR/working/dupdate.img $WORKDIR/output_image

functClean

echo
echo "finished!!!"
echo "your modified ROM is here: $WORKDIR/output_image/dupdate.img"
echo
