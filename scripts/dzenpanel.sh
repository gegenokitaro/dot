bg="#292929"
fg="#ffffff"
font1="Monaco-9"
font2="M+ 1m-9"

gdvtc="gdbar -s v"

icon1="/home/kagura/.icons/xbm8x8"
icon2="/home/kagura/.icons/xpm"

ar="^i($icon1/arrow_big_01.xbm)"

DZEN="dzen2 -p -h 21 -w 325 -x 955 -y 1004 -e 'button3=' -ta r -bg $bg -fn $font1 -fg $fg"

clock() {
	jam=$(date +%R)
	echo -n "$jam"
	return
}

vol() {
	speaker=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1 | cut -d "%" -f1)
	echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-) $speaker ^ca()^ca()"
	return
}

volumemaster() {
        speaker=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-) $(echo $speaker | gdbar -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)^ca()^ca()"
        return
}

volumepcm() {
        speaker=$(amixer sget PCM | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set PCM 5%+)^ca(5,amixer set PCM 5%-) $(echo $speaker | gdbar -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)^ca()^ca()"
        return
}

volumefront() {
        speaker=$(amixer sget Front | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Front 5%+)^ca(5,amixer set Front 5%-) $(echo $speaker | gdbar -fg "#ffffff" -bg "#a0a0a0" -w 40 -h 2 -nonl)^ca()^ca()"
        return
}

speaker() {
	speaker=$(amixer sget PCM | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
	echo -n "$speaker"
	return
}

music() {
	artist=$(mpc -f %artist% current)
	echo -n "^ca(1, mpc toggle)^ca(4, mpc next)^ca(5, mpc prev) $artist ^ca()^ca()^ca()"
	return
}

while :; do
echo "^fg(#dd771f)$ar^fg()^bg(#dd771f)^fn("M+ 1m-9")$(music)^fn()^fg(#292929)$ar^fg()^bg() \
^ca(1, sh /home/kagura/scripts/volume.sh)^i("$icon1/spkr_01.xbm")$(vol)^ca()\
^fg(#7cbd8b)$ar^fg()^bg(#7cbd8b)^fg($bg)$(clock)^fg() ^bg()"
done | $DZEN
