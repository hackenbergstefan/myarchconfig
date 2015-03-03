#!/bin/sh
MAILDIR=/home/stefan/Mail/t-online
ARCHIVEDIR=home/stefan/Mail/archive/t-online
pushd $MAILDIR
find . -type f -print0 | while IFS= read -r -d $'\0' line; do
    MAILDATE=`date +%s -d "$(sed -rn -e '0,/Date/s/^Date: (.*?)($|\\n.*)/\1/p' "$line")"`
    ARCHIVEDATE=`date -d "1 year ago" +%s`
    #echo "$line" "$MAILDATE" "$ARCHIVEDATE"
    if [[ $MAILDATE -le $ARCHIVEDATE ]]; then
      LINEPATH=`echo $line | sed -n -e 's/^.*\///p'`
      echo "rsync -av $line $ARCHIVEDIR/$LINEPATH"
    fi
done
popd
