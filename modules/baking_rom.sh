echo "umounting everything"  >> $LOGFILE 2>&1
echo "umounting everything"
$ELEVATE umount $WORKDIR/mount_path >> $LOGFILE 2>&1

# baking ROM
echo "creating final image" >> $LOGFILE 2>&1
echo "creating final image" 
$WORKDIR/helper/imgrepackerrk /mono /2nd $WORKDIR/working/dupdate.img.dump >> $LOGFILE 2>&1
$WORKDIR/helper/imgrepackerrk /mono $WORKDIR/working/dupdate.img.dump >> $LOGFILE 2>&1

echo "moving final image" >> $LOGFILE 2>&1
echo "moving final image"
mv $WORKDIR/working/dupdate.img $WORKDIR/output_image >> $LOGFILE 2>&1
