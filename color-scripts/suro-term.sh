# don't remove it, just help me to remind people of my city, the great city, SURABAYA
# hokagemadura, or the-cat, or ge, or whatever it is.. 

f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
d=$'\e[1m'
t=$'\e[0m'
v=$'\e[7m'

gtkrc="$HOME/.gtkrc-2.0"
GtkTheme=$( grep "gtk-theme-name" "$gtkrc" | cut -d\" -f2 )
GtkIcon=$( grep "gtk-icon-theme-name" "$gtkrc" | cut -d\" -f2 )
GtkFont=$( grep "gtk-font-name" "$gtkrc" | cut -d\" -f2 )

# Wallpaper set by feh
Wallpaper=$(cat ~/.fehbg | cut -c 16-70)

# Settings from ~/.Xdefaults
xdef="~/.Xdefaults"
TermFont="$(grep 'font' ~/.Xdefaults | awk '{print $2}' | cut -d ":" -f2 | cut -d ":" -f1)"

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
vga=$(lspci | grep -i vga | cut -c62-75)
memkb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram=$(expr $memkb / 1024)

cat << EOF

$d$f4              :                                      $f1 $USER $f6@ $f3$HOSTNAME
$d$f4             d0;                                     
$d$f4            o00k      .':ldkO00000kd:.               $f7 OZ    $f3» $f7$d$dist $bit
$d$f4           c0000l .:dO0000000000000000k,             $f7 WM    $f3» $f7$d$wm
$d$f4          .0000000000000000000000xolx000o             
$d$f4          x0000000000000000000d,     .o00k:.         $f7 Font  $f3» $f7$d$TermFont
$d$f4         '000000000000000000x.         o0000k:       $f7 Theme $f3» $f7$d$GtkTheme
$d$f4         o00000000000000000;           c000000O:     $f7 Icon  $f3» $f7$d$GtkIcon
$d$f4        ;0000000000000000x.            k000o;,cxk.   
$d$f4       '0000000000000000l             o0O:      .;   $f7 RAM   $f3» $f7$d$ram MB
$d$f4       O0000000000000000xol:;'       :0o.            $f7 VGA   $f3» $f7$d$vga
$d$f4      c0000000000000000000xc'       .k,               
$d$f4      O0000000000000Odc,.           ,.               $f7 Machine Description
$d$f4     ;0000000000000k.                                $f7 $lap1 $lap2
$d$f4     o000000000000O.                                 $f7 with hardisk at $size GB
$d$f4     k0000k0000000.                                  
$d$f4     0000k  00000,                                   $f7 Additional Information
$d$f4     0000x .0000c                                    $f7 uptime $f3» $f7$d$uptime
$d$f4     k000000000:                                     $f7 pacman $f3» $f7$d$pacman
$d$f4     '0000000O'                                      
$d$f4      :00000l          $f7        the legend said, there was Suro
$d$f4       ':;'            $f7  who fought greatly at the battle of$f1 SURABAYA
$d$f4                       $f7$t                        -the city of heroes-  

EOF
