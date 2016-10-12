umount $WORKDIR/mount_path

# baking ROM
#echo "creating final image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img.dump >> $LOGFILE 2>&1

#echo "moving final image"
mv $WORKDIR/working/dupdate.img $WORKDIR/output_image >> $LOGFILE 2>&1
