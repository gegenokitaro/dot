info=$(mpc --format %artist%-%album% current | sed 's/ / /g').jpg
test=$(echo ~/.config/ario/covers/$info) 

cp -f "$test" /tmp/cover.jpg 