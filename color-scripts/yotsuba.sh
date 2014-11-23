#!/bin/sh
f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
bld=$'\e[1m'
rst=$'\e[0m'
inv=$'\e[7m'

initializeColor() {
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}

initializeColor

gtkrc="$HOME/.gtkrc-2.0"
GtkTheme=$( grep "gtk-theme-name" "$gtkrc" | cut -d\" -f2 )
GtkIcon=$( grep "gtk-icon-theme-name" "$gtkrc" | cut -d\" -f2 )
GtkFont=$( grep "gtk-font-name" "$gtkrc" | cut -d\" -f2 )

# Wallpaper set by feh
Wallpaper=$(cat ~/.fehbg | cut -c 16-70)

# Settings from ~/.Xdefaults
xdef="~/.Xdefaults"
TermFont="$(grep 'font' ~/.Xdefaults | awk '{print $3}')"

# Time and date
time=$( date "+%H.%M")
date=$( date "+%a %d %b" )

# OS
OS=$(uname -r)
dist=$(cat /etc/*-release | grep -i name | cut -d'=' -d'"' -f2 | sed -n 1p)
bit=$(uname -m)

# WM version
wm=$(wmctrl -m | grep -i name | awk '{print $2}')

# Other
UPT=`uptime | awk -F'( |,)' '{print $2}' | awk -F ":" '{print $1}'`
uptime=$(uptime | sed 's/.*up \([^,]*\), .*/\1/')
uptime2=$(uptime | sed -nr 's/.*\s+([[:digit:]]{1,2}):[[:digit:]]{2},.*/\1/p')
size=$(df | grep '^/dev/[hs]d' | awk '{s+=$2} END {printf("%.0f\n", s/1048576)}')
use=$(df | grep '^/dev/[hs]d' | awk -M '{s+=$3} END {printf("%.0f\n", s/1048576)}')
gb=$(echo "G")
pac=$(pacman -Qe | wc -l)
pacman=$(pacman -Q | wc -l)
COUNT=$(cat /proc/cpuinfo | grep 'model name' | sed -e 's/.*: //' | wc -l)
cpu=$(lscpu | grep 'Model name' | awk -F ':' '{print $2}' | cut -c13-40)
#laptop=$(dmidecode | grep Product)
lap1=$(cat /sys/class/dmi/id/sys_vendor)
lap2=$(cat /sys/class/dmi/id/product_name)

cat << EOF
${bld}${greenf}  cocco c  cccc  ccccoc   cccccc cccocc   ccoc
  occoccc  ccoc ccc  ccccccco cccccccocccccccc     THIS IS INTERESTING!!
   cocco ccccoccccc   cccccccccoccccccoccccccc
    ococcccccocccc      ccccco  ccccccoocccccc     WM:      $wm
    ococccco cccoc        ccccc   cccccccccccc     GTK:     $GtkTheme
    ococccc   occ          cccc     ccccc cccc     Font:    $GtkFont
    ococccc   ccc             oocccccccccc  cc     Icon:    $GtkIcon
    ococcc  cccc                ${blackf}ccccc${greenf} cccc${greenf}         
    ococcccc${blackf} coooc             kookkkkc  c${greenf}         Kernel:  $OS
    cccococ ${blackf}oc okko           ckook00kkc  c${greenf}        CPU:     $cpu
    ccoooc  ${blackf}okkkkkko          ckkkkk0kko   o${greenf}       Packet:  $pacman
     cocccc ${blackf}ckokkook           ckookookc   c${greenf}       HDD:     $use/$size$gb
     co c c  ${blackf}coooooc             coooc${greenf}             
        cc                                         $dist $bit
         c
         cc                                  c
        cccc            ${blackf}------------${greenf}        ok     ||   ||
        c.cccc          ${blackf}\          //${greenf}    cokkk     ||   ||   _===_
        ccccccccc        ${blackf}\        //${greenf}  cccokokk     ||===||    ___=
            cccccccoocccccc${blackf}------' ${greenf}''  cokkkkk     ||   ||   =   =
                 okk0kkkkkkko        cokkkkoco     ||   ||   '==='=
                okkkkkkkkkkkkkoooookkkkkkoc
               ckkkkkkkkcokkkkkkkkkkkkkko

EOF
