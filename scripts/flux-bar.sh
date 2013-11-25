spkr="/home/kagura/.icons/xbm8x8/spkr_01.xbm"

vol() {
	speaker=$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)
	echo -n "^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-)$(echo $speaker | gdbar -w 60 -h 10 -s o -ss 1 -sw 4 -nonl)^ca()^ca()"
	return
}

clock(){
	hour=$(date +%R)
	echo -n " ^fg(#ffffff)^fn(Inconsolata-8:bold)$hour^fn()^fg() "
}

play="^ca(1,mpc toggle)^i(/home/kagura/.icons/xbm8x8/play.xbm)^ca()"
next="^ca(1,mpc next)^i(/home/kagura/.icons/xbm8x8/fwd.xbm)^ca()"
prev="^ca(1,mpc prev)^i(/home/kagura/.icons/xbm8x8/rwd.xbm)^ca()"
stop="^ca(1,mpc stop)^i(/home/kagura/.icons/xbm8x8/stop.xbm)^ca()"

phones="^fg(#ffffff)^fn(Inconsolata-8:bold)MPD^fn() ^i(/home/kagura/.icons/xbm8x8/phones.xbm)^fg()"

colbox="#676767"

box="^fg($colbox)^r(75x24)^fg()"

while :; do
echo " $phones $box ^fg(#ffffff)^bg($colbox) ^ib(1)^pa(60)$prev $play $stop $next^bg() ^pa()^ib()\
  ^i($spkr) $(vol) $(clock)^fg()"
sleep 1
done | dzen2 -p -x 960 -bg "#494949" -h 32 -w 320 -ta r -e 'button3='
