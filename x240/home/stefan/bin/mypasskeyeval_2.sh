#!/bin/bash

cd ~/.keys

echo "bla"
expect -c "
spawn -noecho zsh
send \"mypasscopy \"
interact {
    \r {send \"\r\"; expect \"% \"; return}
}
"

sleep 1
exit
