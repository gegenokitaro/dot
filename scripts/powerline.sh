#!/bin/bash

font="M+ 1c-7:Bold"
black="#000000"
white="#FFFFFF"
grey1="#808080"
grey2="#303030"
grey3="#151515"
icon="/home/hokage/.icons/stlarch"
icon2="/home/hokage/.icons/xbm8x8"

yaxis=1348
xaxis=500

width=866

while :; do
echo "^fg($grey2)⮂^fg()^fg($grey1)^p(-6)^bg($grey2) ^i($icon/note6.xbm) ^p()^p(0)⮂^bg()^bg($grey1)^fn($font)^fg($black)^p(-6)^ca(4,mpc next)^ca(5,mpc prev)  $(mpc current -f %artist%)^fg()  ^fn()^fg()^bg($grey1)^fg($black)⮂^p()^fg()^bg($black)^fg($white)^fn($font)^p(-6)  $(mpc current -f %title%)  ^ca()^ca()\
^fn()^fg()^fg($grey2)⮂^fg()^fg($grey1)^p(-6)^bg($grey2) ^i($icon2/bat_full_02.xbm) ^p()^p(0)⮂^bg()^bg($grey1)^fn($font)^fg($black)^p(-6)  $(acpi | awk '{print $4}' | sed 's/,$//') $(acpi -b | cut -d ' ' -f 3 | tr -d ',') ^fg() \
^fn()^fg()^fg($grey2)⮂^fg()^fg($grey1)^p(-6)^bg($grey2) ^i($icon2/clock.xbm) ^p()^p(0)^fg($black)⮂^fg()^bg()^bg($black)^fn($font)^fg($white)^p(-6)  $(date +"%A, %d %b %Y")^fg()  ^fn()^fg()^bg($black)^fg($white)⮂^p()^fg()^bg($white)^fg($black)^fn($font)^p(-6)  $(date +%R)  ^fn()^fg()" 
done | dzen2 -p -fn "Inconsolata\-dz for Powerline" -h 17 -ta r -w $width -x $xaxis -bg $black

