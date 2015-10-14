#!/bin/sh

nohup /usr/bin/gnome-screensaver-command --lock &
/usr/bin/dbus-send --system --print-reply --dest="org.freedesktop.UPower" /org/freedesktop/UPower org.freedesktop.UPower.Suspend
