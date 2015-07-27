f=3 b=4
for j in f b; do
  for i in {0..7}; do
    printf -v $j$i %b "\e[${!j}${i}m"
  done
done
d=$'\e[1m'
t=$'\e[0m'
v=$'\e[7m'

clr1=$(cat ~/.Xresources | grep -i color1 | head -1 | awk '{print $2}' )
clr2=$(cat ~/.Xresources | grep -i color2 | head -1 | awk '{print $2}' )
clr3=$(cat ~/.Xresources | grep -i color3 | head -1 | awk '{print $2}' )
clr4=$(cat ~/.Xresources | grep -i color4 | head -1 | awk '{print $2}' )
clr5=$(cat ~/.Xresources | grep -i color5 | head -1 | awk '{print $2}' )
clr6=$(cat ~/.Xresources | grep -i color6 | head -1 | awk '{print $2}' )
clr7=$(cat ~/.Xresources | grep -i color7 | head -1 | awk '{print $2}' )
clr1b=$(cat ~/.Xresources | grep -i color9 | head -1 | awk '{print $2}' )
clr2b=$(cat ~/.Xresources | grep -i color10 | head -1 | awk '{print $2}' )
clr3b=$(cat ~/.Xresources | grep -i color11 | head -1 | awk '{print $2}' )
clr4b=$(cat ~/.Xresources | grep -i color12 | head -1 | awk '{print $2}' )
clr5b=$(cat ~/.Xresources | grep -i color13 | head -1 | awk '{print $2}' )
clr6b=$(cat ~/.Xresources | grep -i color14 | head -1 | awk '{print $2}' )
clr7b=$(cat ~/.Xresources | grep -i color15 | head -1 | awk '{print $2}' )

black=$(cat ~/.Xresources | grep -i color0 | head -1 | awk '{print $2}' )
blackb=$(cat ~/.Xresources | grep -i color8 | head -1 | awk '{print $2}' )

cat << EOF

 $f1▀▀▀▀▀ $d▀$t    $f2▀▀▀▀▀ $d▀$t    $f3▀▀▀▀▀ $d▀$t    $f4▀▀▀▀▀ $d▀$t    $f5▀▀▀▀▀ $d▀$t    $f6▀▀▀▀▀ $d▀$t    $f7▀▀▀▀▀ $d▀$t
 $f1$clr1    $f2$clr2    $f3$clr3    $f4$clr4    $f5$clr5    $f6$clr6    $f7$clr7  
$d $f1$clr1b    $f2$clr2b    $f3$clr3b    $f4$clr4b    $f5$clr5b    $f6$clr6b    $f7$clr7b  

EOF
