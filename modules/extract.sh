# creating backup of image
echo "creating working copy of ROM image"
cp -a $WORKDIR/orig_image/dupdate.img $WORKDIR/working/

# extract image
echo "extracting image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img

# mounting image
echo
echo "mounting system.img"
mount $WORKDIR/working/dupdate.img.dump/Image/system.img $WORKDIR/mount_path

if [!-d "$WORKDIR/mount_path/app"]; then
    echo "mounting failed! exiting...";
    functClean
    exit;
fi;

echo "done mounting"
