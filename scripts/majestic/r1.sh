

while :; do
echo " ^fg(#ffffff)$(mpc -f %artist% current | tr '[:lower:]' '[:upper:]')\
 ^fg(#00ccff)$(mpc -f %title% current | tr '[:lower:]' '[:upper:]') "
 sleep 1
done | dzen2 -x 80 -y 860 -h 30 -expand r -fn "M+ 1m:pixelsize=16"