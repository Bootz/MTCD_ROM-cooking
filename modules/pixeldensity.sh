echo '' >> $LOGFILE 2>&1
echo '[dialog: ask user to adjust pixel density]' >> $LOGFILE 2>&1

dialog --backtitle "Pixel density" \
   --radiolist "Select pixel density: " 15 40 15\
   1 Keep_default on\
   2 240 off \
   3 160 off 2>$_temp

menuitem=`cat $_temp`
rm $_temp

case "$menuitem" in
   1)
      echo 'Keep default' >> $LOGFILE 2>&1
      ;;
   2)
      sed -i 's/ro.sf.lcd_density.*/ro.sf.lcd_density=240/' $WORKDIR/mount_path/build.prop >> $LOGFILE 2>&1
      ;;
   3)
      sed -i 's/ro.sf.lcd_density.*/ro.sf.lcd_density=160/' $WORKDIR/mount_path/build.prop >> $LOGFILE 2>&1
      ;;
   255) ;;
   *)   
esac
