#! /bin/sh

position(){
pos=$(mpc | awk 'NR==2' | awk '{print $4}' | sed 's/(//' | sed 's/%)//')
bar=$(echo $pos | gdbar -w 190 -h 1.5 -fg "#FF3D00" -bg "#821D00")
echo -n "$bar"
return
}

font="M+ 1c-7"
icon="/home/hokage/.icons/xbm8x8"

while :; do
echo "   $(mpc current -f %artist%)
   $(mpc current -f %title%) 
   $(mpc current -f %album%)

^p(65)^ca(1,mpc prev)^i($icon/prev.xbm)^ca()   ^ca(1,mpc toggle)^i($icon/play.xbm)^ca()   ^ca(1,mpc stop)^i($icon/stop.xbm)^ca()   ^ca(1,mpc next)^i($icon/next.xbm)^ca()
$(position)" 
done | dzen2 -p -y 25 -x 883 -l 5 -u -w 190 -ta l -fn "$font" -e 'onstart=uncollapse;key_Escape=ungrabkeys,exit'
