#!/bin/zsh

sleep 3

# xrandr --output VIRTUAL1 --off --output DP3 --mode 1920x1080 --pos 3280x0 --rotate normal --output eDP1 --mode 1360x768 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --primary --mode 1920x1080 --pos 1360x0 --rotate normal --output DP2 --off
# feh --bg-scale ~/.config/wall.jpg

nm-applet&

# workspace window app
function launch_app {
	THE_COMMAND=`which $3`
	i3-msg "workspace ${1}; exec ${THE_COMMAND}"
	(sleep 10; i3-msg workspace $1 && i3-msg move workspace to output $2) &
	sleep 0.25
}

#declare -A config

#read the current capslock state - result should be "on" or "off"
caps=`xset -q | grep Caps | awk '{ print $4 }'`

#if capslock is on at login, skip running these apps at startup
if [ $caps = off ]; then
	launch_app 1 eDP1 firefox
	launch_app 2 eDP1 terminator
	launch_app 9 eDP1 telegram-desktop -startintray
else
	#do nothing
fi

#python script for renaming
(sleep 20; /home/oleksandrputin/.config/i3/autoRenameWindows.py) &


exit
