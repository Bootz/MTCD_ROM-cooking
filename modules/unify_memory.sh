#!/bin/bash
# check if already a ROM is in place. Download JY ROM from Google Drive

        dialog --title "unify memory" \--yesno "Do you want unify all partitions into a single big one? REMEBMER: wipe and apply factory defaults TWO times to make this work!!!" 7 60

        response=$?
        case $response in
        0) 
		echo "parameters file ..."
		sed -i 's/CMDLINE.*/CMDLINE:init=\/init initrd=0x62000000,0x00800000 mtdparts=rk29xxnand:0x00002000@0x00002000(misc),0x00006000@0x00004000(kernel),0x00006000@0x0000A000(boot),0x00010000@0x00010000(recovery),0x00020000@0x00020000(backup),0x00040000@0x00040000(cache),0x00008000@0x00080000(metadata),0x00002000@0x00088000(kpanic),0x00180000@0x0008A000(system),0x00040000@0x0020A000(oem),-@0x0024A000(userdata)/' $WORKDIR/working/dupdate.img.dump/parameter
		sed -i 's/CMDLINE.*/CMDLINE:init=\/init initrd=0x62000000,0x00800000 mtdparts=rk29xxnand:0x00002000@0x00002000(misc),0x00006000@0x00004000(kernel),0x00006000@0x0000A000(boot),0x00010000@0x00010000(recovery),0x00020000@0x00020000(backup),0x00040000@0x00040000(cache),0x00008000@0x00080000(metadata),0x00002000@0x00088000(kpanic),0x00180000@0x0008A000(system),0x00040000@0x0020A000(oem),-@0x0024A000(userdata)/' $WORKDIR/working/dupdate.img.dump/parameter.parm
		sed -i 's/BlockCount.*/BlockCount = false/' $WORKDIR/working/dupdate.img.dump/image.cfg
        
;;
        1) ;;

        255) ;;
        esac
