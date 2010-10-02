wmiir write /rules <<!
    # Apps with system tray icons like to their main windows
    # Give them permission.
    /^Pidgin:/ allow=+activate

    # ROX puts all of its windows in the same group, so they open
    # with the same tags.  Disable grouping for ROX Filer.
    /^ROX-Filer:/ group=0

    /^kupfer.py:/ -> /./
!

#Set desktop background
xloadimage -onroot ~/billeder/walls/water.jpg

#Autostart apps
wihack -tags '/./' kupfer >/dev/null &
wihack -tags 0 urxvt -e cmus &
mkfifo /home/peter/.conky2wmii &
conky &

#start and move pidgin friend list and kill kupfer window
bash -c '
	wihack -tags 0 pidgin >/dev/null &
	COUNTER=0
	while [  $COUNTER -lt 30 ]; do
		for i in $(wmiir ls /client | grep -Eo "^[[:alnum:]]*"); do
			wmiir cat "/client/$i/props" | grep -q Pidgin:Pidgin:Venneliste && wmiir xwrite /tag/0/ctl send $i right 2>/dev/null && exit
		done
		sleep 1
		let COUNTER=COUNTER+1
	done
' &

bash -c '
	COUNT=0
	while [  $COUNT -lt 30 ]; do
		for i in $(wmiir ls /client | grep -Eo "^[[:alnum:]]*"); do
			wmiir cat "/client/$i/props" | grep -q kupfer.py:Kupfer.py:Kupfer && wmiir xwrite /client/$i/ctl kill && exit
		done
		sleep 1
		let COUNT=COUNT+1
	done
' &
