#!/bin/bash

#
#
# credits to: https://dev.to/leandronsp/building-a-web-server-in-bash-part-iii-login-a03
#

# variables ##################################################################

LISTEN_PORT=9999
RESPONSE_QUEUE=response.fifo

# functions ##################################################################

function processRequest() {
    while read line; do
        echo $line
        trline=`echo $line | tr -d '[\r\n]'`  # remove \r\n
        
        if [ -z "$trline" ]; then             # empty after removing \r\n ?
            break
        fi

        HEADLINE_REGEX='(.*?)\s(.*?)\sHTTP.*?'        

        if [[ "$trline" =~ $HEADLINE_REGEX ]]; then
            REQUEST=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1 \2/"); 
            HTTP_VERB=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\1/");
            HTTP_PATH=$(echo $trline | sed -E "s/$HEADLINE_REGEX/\2/");
            #read -r REQUEST_METHOD REQUEST_URI REQUEST_HTTP_VERSION <<<"$trline"
            #echo ">>> verb: " $REQUEST_METHOD " uri: " $REQUEST_URI " ver: "$REQUEST_HTTP_VERSION
        fi
    done
    
    echo "Verb $HTTP_VERB   path: $HTTP_PATH"
    case "$REQUEST" in
        "GET /") RESPONSE=$(cat pong.html) ;;
        "GET /open") RESPONSE=$(firefox "https://startpage.com" && cat pong.html) ;;
        *) RESPONSE=$(cat not_found.html) ;;
    esac

    echo -e $RESPONSE > $RESPONSE_QUEUE
}

# startup ####################################################################
rm -f $RESPONSE_QUEUE
mkfifo $RESPONSE_QUEUE

# server main loop ###########################################################
while true; do
    cat $RESPONSE_QUEUE | nc -lN $LISTEN_PORT | processRequest
done