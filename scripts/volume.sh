pid="/tmp/vol-dzen.pid"

if [ -e $pid ]; then
	kill -9 $(<"$pid")
	rm $pid
	exit
fi

DZEN="dzen2 -p -h 100 -w 145 -x 1120 -y 898 -fg "#292929" -e "button3=""

gdbarv="gdbar -s v -h 75 -w 3"

vol() {
	speaker=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
	echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
	return
}

volpcm() {
        speaker=$(amixer sget PCM | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set PCM 5%+)^ca(5,amixer set PCM 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
        return
}

volhead() {
        speaker=$(amixer sget Headphone | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Headphone 5%+)^ca(5,amixer set Headphone 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
        return
}


volfront() {
        speaker=$(amixer sget Front | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Front 5%+)^ca(5,amixer set Front 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
        return
}

volsur() {
        speaker=$(amixer sget Surround | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Surround 5%+)^ca(5,amixer set Surround 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
        return
}

volcen() {
        speaker=$(amixer sget Center | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
        echo -n "^ca(4,amixer set Center 5%+)^ca(5,amixer set Center 5%-)$(echo $speaker | $gdbarv)^ca()^ca()"
        return
}

while :; do
echo "$(vol)  $(volpcm)  $(volhead)  $(volfront)  $(volcen)  $(volsur)"
done | $DZEN & echo $! > $pid
