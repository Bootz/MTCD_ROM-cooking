# creating backup of image
echo "creating working copy of ROM image"
cp -a $WORKDIR/orig_image/dupdate.img $WORKDIR/working/ >> $LOGFILE 2>&1

# extract image
echo "extracting image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img >> $LOGFILE 2>&1

# mounting image
echo
echo "mounting system.img"
mount $WORKDIR/working/dupdate.img.dump/Image/system.img $WORKDIR/mount_path >> $LOGFILE 2>&1

if [ ! -d $WORKDIR/mount_path/app ]; then
    echo "mounting failed! exiting..."
    functClean
    exit;
fi

echo "done mounting"
