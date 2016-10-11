dialog --backtitle "Choose languange" \
  --radiolist "Select default languange: " 15 40 15\
        1 English  on\
        2 Dutch off \
        3 French off \
        4 German off \
        5 Russian off \
	6 Spanish off 2>$_temp

menuitem=`cat $_temp`
rm $_temp

case "$menuitem" in
        1)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=en/' $WORKDIR/mount_path/build.prop
                ;;
        2)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=nl/' $WORKDIR/mount_path/build.prop
                ;;
        3)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=fr/' $WORKDIR/mount_path/build.prop
                ;;
        4)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=de/' $WORKDIR/mount_path/build.prop
                ;;
        5)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=ru/' $WORKDIR/mount_path/build.prop
                ;;
        6)
                sed -i 's/ro.product.locale.language.*/ro.product.locale.language=es/' $WORKDIR/mount_path/build.prop
                ;;
	255) functClean & exit 1;;
        *)    functClean & exit 1
esac
