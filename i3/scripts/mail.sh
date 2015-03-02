#!/bin/sh

mails=`find ~/Mail/$1/*/new -type f | wc -l`
if ! [[ $mails == "0" ]]; then
  echo "✉ ${mails}"
fi
