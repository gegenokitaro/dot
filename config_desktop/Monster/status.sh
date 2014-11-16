#too lazy to put interpreter

mus() {
	music="$(mpc current -f "%artist% - [%title%|%file%]")"
	if [ -z "$music" ]; then music="stopped" mstat=""
	else
    		mstat="$(mpc | sed -rn '2s/\[([[:alpha:]]+)].*/\1/p')"
    		[ "$mstat" == "paused" ] && mstat="" || mstat=""
	fi
	echo "%{B#FF272727}%{U#FF364069}%{+u} $mstat %{-u}%{B} $music "
}

vol() {
	if [ "$(amixer get Master | sed -nr '$ s:.*\[(.+)]$:\1:p')" == "off" ]
	then vol="[m]" vstat=""
	else
    		vol="$(amixer get PCM | sed -nr '$ s:.*\[(.+%)].*:\1:p')"
    	if   [ "${vol%\%}" -le 10 ]; then vstat=""
    	elif [ "${vol%\%}" -le 20 ]; then vstat=""; else vstat=""; fi
	fi
	echo $vstat $vol
}

bat() {
	bat="$(acpi | awk '{print $4}' | sed 's/,//g' )"
	if [ "$(acpi | awk '{print $3}')" == "Discharging," ]
	then bstat=""
	else
	bstat=""
	fi
	echo "%{B#FF272727} $bstat %{F#FF364069}◀%{F}%{B#FF364069} pow: $bat %{B}"
}

while :; do
date="$(date +"%a, %b %d %R")" dstat=""
echo "%{r} $(mus) $(bat)%{B#FF272727} $date %{B}"
sleep 1
done | bar -p -d -g 1066x17+300+0 -f '-*-lemon-*-*-*-*-10-*-*-*-*-*-*-*,-*-stlarch-*-*-*-*-10-*-*-*-*-*-*-*' -u 3 -B '#FF161616' -F "FF9A9A9A" 
