#!/bin/sh

# chromium with user agent switchers

# Author: allex (allex.wxn@gmail.com
# Last Modified: Fri Feb 10, 2012 04:38PM

cat<<MENU
1) iphone
2) ipad
MENU

UA=""
PAC_URL="http://local/dev/proxy.pac"

echo -n "Choose user agent type:"
read type
case "$type" in
    1)
        UA="Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_1 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8B117 Safari/6531.22.7"
        ;;
    2)
        UA="Mozilla/5.0 (iPad; U; CPU OS 3_2_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B500 Safari/531.21.10"
        ;;
    *)
        echo "Error, No host"
        ;;
esac

nohup chromium-browser --user-agent="$UA" --proxy-pac-url="$PAC_URL">/dev/null 2>&1 &

unset UA
unset PAC_URL
