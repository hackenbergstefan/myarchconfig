import re
import os

muttfolder = "/home/stefan/.mutt"
mailboxfile = "/home/stefan/.mutt/mailboxes"

with open(mailboxfile) as f:
    s = f.read()
f.close()

mboxes = dict()

for (acc,mbox) in re.findall('"\+([^/]+)/([^"]+)',s):
    if not acc in mboxes:
        mboxes[acc] = ([],[])
    # handle special mailboxes
    if mbox == "INBOX":
        mboxes[acc][0].insert(0,'"+'+mbox+'"')
    elif mbox == "Sent":
        mboxes[acc][0].insert(1,'"+'+mbox+'"')
    elif mbox == "Drafts":
        mboxes[acc][0].insert(2,'"+'+mbox+'"')
    elif mbox == "Archive":
        mboxes[acc][0].insert(3,'"+'+mbox+'"')
    elif mbox == "Junk":
        mboxes[acc][0].insert(4,'"+'+mbox+'"')
    elif mbox == "Trash":
        mboxes[acc][0].insert(5,'"+'+mbox+'"')
    else:
        mboxes[acc][1].append('"+'+mbox+'"')

for key in mboxes:
    mboxes[key] = (mboxes[key][0],sorted(mboxes[key][1]))
    with open(os.path.join(muttfolder,"mailboxes."+key),'w') as f:
        f.write("mailboxes")
        f.write(" "+' '.join(mboxes[acc][0]))
        f.write(" "+' '.join(mboxes[acc][1]))



