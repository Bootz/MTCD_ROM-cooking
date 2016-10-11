#!/bin/bash
WORKDIR=$(pwd)
_temp="$WORKDIR/working/answer.$$"
LOGFILE=$WORKDIR/working/log

# clean up if process is cancelled
function functClean
{
	echo "cleaning up..."
	echo
	if mountpoint -q $WORKDIR/mount_path 
	then
		echo "umounting image"
		umount $WORKDIR/mount_path >> $LOGFILE 2>&1
	fi
	echo "remove working files"
	rm -rf $WORKDIR/working/*
	echo
}


# download if necessary
. $WORKDIR/modules/download.sh
#
# backup, extract and mount system.img
. $WORKDIR/modules/backup_extract_mount.sh


#################
# starting 
#################

. $WORKDIR/modules/remove_apps.sh
. $WORKDIR/modules/timeformat.sh
. $WORKDIR/modules/choose_addons.sh
. $WORKDIR/modules/language.sh
. $WORKDIR/modules/patching.sh
. $WORKDIR/modules/unify_memory.sh
#. $WORKDIR/modules/install_supersu.sh

# baking ROM
echo "creating final image"
$WORKDIR/helper/imgrepackerrk $WORKDIR/working/dupdate.img.dump >> $LOGFILE 2>&1

echo "moving final image"
mv $WORKDIR/working/dupdate.img $WORKDIR/output_image >> $LOGFILE 2>&1

# cleaning up
functClean

echo
echo "finished!!!"
echo "your modified ROM is here: $WORKDIR/output_image/dupdate.img"
echo
