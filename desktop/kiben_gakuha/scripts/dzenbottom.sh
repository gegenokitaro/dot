icon="/home/kagura/.icons/xbm8x8/arrow_big_02.xbm"
phones="/home/kagura/.icons/xbm8x8/phones.xbm"

pink="#E65C73"
green="#49C259"
blue="#5DBFFF"
yellow="#E0DA37"
magenta="#C768C8"

music() {
	artist=$(mpc -f %artist% current)
	title=$(mpc -f %title% current)
	album=$(mpc -f %album% current | cut -c1-20)
	time=$(mpc -f %time% current)
	echo -n "^bg($blue) ^i($phones) $artist^bg($pink)^fg($blue)^i($icon)^fg() $title^bg($yellow)^fg($pink)^i($icon)^fg() $album^bg($green)^fg($yellow)^i($icon)^fg() $time^bg($magenta)^fg($green)^i($icon)"
}

volmpd() {
	pcm=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
	echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-)^fg() $pcm^bg()^fg($magenta)^i($icon)^fg()^ca()^ca()"
}

line="^fg(#101010)^ib(2)^pa(0;0)^r(1280x3) ^ib(2)^pa(0;23)^r(1280x3)^fg()"

while :; do
echo "^ca(1, sh /home/kagura/scripts/mpdcontrol.sh)$(music)^ca()$(volmpd) "
sleep 1
done | dzen2 -p -h 22 -ta l -y 1004 -w 700 -bg "#101010" -fg "#000000" -fn "M+ 1m-8" -e 'button3=' -title-name dzenbottom && sleep .01s && transset-df -n dzenbottom 0.9
