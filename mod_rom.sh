#!/bin/bash
WORKDIR=$(pwd)
_temp="$WORKDIR/working/answer.$$"
LOGFILE=$WORKDIR/logfile

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

# remove old logfile
if [ -f $LOGFILE ]; then
	rm $LOGFILE
fi

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
. $WORKDIR/modules/performance.sh
. $WORKDIR/modules/unify_memory.sh
. $WORKDIR/modules/install_supersu.sh

# not working or not necessary
#. $WORKDIR/modules/enable_init.d.sh
#. $WORKDIR/modules/tune_cpu.sh

# must be the last one as we have to mount a different image
. $WORKDIR/modules/remove_oem_apps.sh

# baking rom
. $WORKDIR/modules/baking_rom.sh


# cleaning up
functClean

echo
echo "finished!!!"
echo "your modified ROM is here: $WORKDIR/output_image/dupdate.img"
echo "logilfe is here: $WORKDIR/logfile"
echo
