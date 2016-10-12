# cd to dir so ls -d is working
cd $WORKDIR/addons

pkglist=""
n=1
for pkg in $(ls -d *)
do
        pkglist="$pkglist $pkg $n off"
        n=$[n+1]
done

cd $WORKDIR

choices=`/usr/bin/dialog --stdout --checklist 'Choose APKs you want to ADD:' 80 80 80 $pkglist`


if [ $? -eq 0 ]
then
        for choice in $choices
        do
                TEMP="$TEMP $choice"
        done
fi


if [ $choice!="" ]; then


	dialog --title "Include add-ons" \--yesno "Are you sure you want to add \n $TEMP to your image?" 7 60

	response=$?
	case $response in
	   0) echo "Adding selected APKs"

        	for choice in $choices
	        do
	                echo "Adding $choice"
	                echo $WORKDIR/mount_path/app/$choice
	                cp -a $WORKDIR/addons/$choice $WORKDIR/mount_path/app
	        done
		;;
	
	   #do nothing
	   1)  ;;
	   #do nothing
	   255) ;;
	esac

fi

unset choices
unset TEMP
