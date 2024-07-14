#!/usr/bin/env bash

op=$( echo -e "  Poweroff\n Reboot\n Suspend\n  Lock\n  Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )

case $op in 
        poweroff)
                ;&
        reboot)
                ;&
        suspend)
                systemctl $op;;
        lock)
		            pidof hyprlock || hyprlock;;
        logout)
                hyprctl dispatch exit;;
esac
