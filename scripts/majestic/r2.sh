weather=$(curl -s "http://weather.yahooapis.com/forecastrss?w=1044316&u=c" -o ~/.cache/weather.xml)

while :; do
echo "^ca(1, $weather)\
 ^fg(#ffffff)$(grep "yweather:condition" ~/.cache/weather.xml | grep -o "text=\"[^\"]*\"" | grep -o "\"[^\"]*\"" | grep -o "[^\"]*" | tr '[a-z]' '[A-Z]')\
 ^fg(#00ccff)$(grep "yweather:condition" ~/.cache/weather.xml | cut -d "m" -f2 | cut -d "=" -f2 | cut -d '"' -f2)^fn(M+ 1m:pixelsize=7) ^p(;-5)O^fn()^ca() " 
sleep 1
done | dzen2 -x 80 -y 900 -h 30 -expand r -fn "M+ 1m:pixelsize=16"