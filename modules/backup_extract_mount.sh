# creating backup of image
echo "creating working copy of ROM image"
cp -a $WORKDIR/orig_image/dupdate.img $WORKDIR/working/ >> $LOGFILE 2>&1

# extract image
echo "extracting image to $WORKDIR/working/"
$WORKDIR/helper/imgrepackerrk /mono $WORKDIR/working/dupdate.img >> $LOGFILE 2>&1
$WORKDIR/helper/imgrepackerrk /mono /2nd $WORKDIR/working/dupdate.img >> $LOGFILE 2>&1

# mounting image
echo
echo "mounting system.img"
mount $WORKDIR/working/dupdate.img.dump/Image/system.img $WORKDIR/mount_path >> $LOGFILE 2>&1

if [ ! -d $WORKDIR/mount_path/app ]; then
   echo "mounting failed! exiting..."
   functClean
   exit;
else
   echo "bugfix: one file in mount_path/bin has wrong owner...?"
   chown root:2000 $WORKDIR/mount_path/bin/displayd
fi

echo "done mounting"
