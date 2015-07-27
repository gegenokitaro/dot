red="#FF6E84"
magenta="#F299FC"
green="#B5FF57"
blue="#57DAFF"
blue2="#85D7FF"
orange="#FFB557"
pink="#FFB1ED"
yellow="#FFF585"

icon="/home/kagura/.icons/xbm8x8/arrow_mini_01.xbm"

weather() {
	get='curl -s "http://weather.yahooapis.com/forecastrss?w=1044316&u=c" -o ~/.cache/weather.xml'
	status=$(grep "yweather:condition" ~/.cache/weather.xml | grep -o "text=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | tr '[a-z]' '[A-Z]')
	temp=$(grep "yweather:condition" ~/.cache/weather.xml | cut -d "m" -f2 | cut -d "=" -f2 | cut -d '"' -f2)
	echo -n "^fg($red)^i($icon)^fg() ^ca(1, $get)^fg($green)$status ^fg($red)^i($icon) ^fg($blue)$temp^fg()^ca()"
}

hour="date +%R"
day="date +%A | tr '[:lower:]' '[:upper:]'"
date="date +%d"
month="date +%B | tr '[:lower:]' '[:upper:]'"
year="date +%Y"

while :; do
echo " ^fg($pink)$(date +%A | tr '[:lower:]' '[:upper:]')^fg() \
^fg($red)^i($icon)^fg() \
^fg($yellow)$(date +%d) \
^fg($magenta)$(date +%B | tr '[:lower:]' '[:upper:]') \
^fg($blue2)$(date +%Y) \
$(weather) ^fg($red)^i($icon) ^fg(orange)$(date +%R)^fg() "
sleep 1
done | dzen2 -p -w 580 -x 700 -y 1004 -ta r -h 22 -bg "#101010" -fn "M+ 1m-8" -e 'button3=' -title-name dzencorner && sleep .01s && transset-df -n dzencorner 0.9
