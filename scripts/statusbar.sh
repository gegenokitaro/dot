#!/bin/bash
# Font
# FONT="Neep:pixelsize=9"
FONT="Envy Code R-7"
#FONT="Monaco:size=9" 

# Colors
BG="#151515"
FG="#303030"

RED="#E84F4F"
LRED="#D23D3D"

GREEN="#B8D68C"
LGREEN="#A0CF5D"

YELLOW="#E1AA5D"
LYELLOW="#F39D21"

BLUE="#7DC1CF"
LBLUE="#4E9FB1"

MAGENTA="#9B64FB"
LMAGENTA="#8542FF"

CYAN="#0088CC"
LCYAN="#42717B"

ICON="/home/hokage/.icons/xbm8x8/"
ICON2="/home/hokage/.icons/stlarch/"

bat()
{
  batval=$(acpi | awk '{print $4}' | sed 's/,$//')
  batstat=$(acpi -b | cut -d ' ' -f 3 | tr -d ',')
  batbar=$(echo $batval | gdbar -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)
  icon1="^i($ICON"ac_01.xbm")"
  icon2="^i($ICON"ac.xbm")"
  if [ $batstat == "Discharging" ]; then
       echo -n "^fg($GREEN)$icon2^fg() $batval $batbar "
  else 
       echo -n "^fg($CYAN)$icon1^fg()"
       if [ $batstat == "Full" ];then
            echo -n "  ^fg($YELLOW)<<  FULL  >>^fg() "
       else 
            echo -n " $batval $batbar "
       fi
  fi
  return
}

memory()
{
  MEM=$(free -m | grep '-' | awk '{print $3}')
  echo -n "^fg($CYAN)^i($ICON"mem.xbm")^fg() ${MEM} M"
  return
}

music()
{
  gmpc=$(mpc current)
  if [ $gmpc == null ]; then
       echo -n "Not Playing"
  else
       echo -n "^ca(1,mpc toggle)^ca(4,mpc next)^ca(5,mpc prev)$gmpc^ca()^ca()^ca()"
  fi
  return
}

musicplayer()
{
  echo -n "^ca(1,mpc prev)^i($ICON"prev.xbm")^ca()"
  echo -n "^ca(1,mpc play)^i($ICON"play.xbm")^ca()"
  echo -n "^ca(1,mpc stop)^i($ICON"stop.xbm")^ca()"
  echo -n "^ca(1,mpc next)^i($ICON"next.xbm")^ca()"
}

vol()
{
  speaker=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
  echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-) ${speaker} $(echo $speaker | gdbar -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)^ca()^ca()"
  return
}

clock()
{
  time=$(date +%R)
  echo -n "^fg($CYAN)^i($ICON"clock.xbm")^fg() $time"
  return
}

cpu()
{
  freq=$(grep "cpu MHz" /proc/cpuinfo | head -1 | awk '{print $4}' | gdbar -max 9200 -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)
  echo -n " ^fg($CYAN)^i($ICON"cpu.xbm")^fg() $freq "
  return
}

while :; do
echo "^fg($CYAN)^ca(1,mpc toggle)^i($ICON2"note6.xbm")^ca()^fg() $(music) \
$(memory) \
$(cpu) \
$(bat) \
^fg($CYAN)^i($ICON"spkr_01.xbm")^fg()$(vol) \
$(clock) " 
sleep 1
done 
# | dzen2 -p -fn "Envy Code R-7" -h 18 -w 866 -x 500 -ta r
