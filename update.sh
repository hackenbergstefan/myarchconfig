#!/bin/sh
echo "copy"
echo
cp -vu ~/.Xresources           ~/myarchconfig/Xresources
cp -vu ~/.aliasrc              ~/myarchconfig/aliasrc
cp -vu ~/.bash_profile         ~/myarchconfig/bash_profile
cp -vu ~/.bashrc               ~/myarchconfig/bashrc
cp -vu ~/.tmux.conf            ~/myarchconfig/tmux.conf
cp -vu ~/.vimencrypt           ~/myarchconfig/vimencrypt
cp -vu ~/.vimrc                ~/myarchconfig/vimrc
cp -vu ~/.xinitrc              ~/myarchconfig/xinitrc
cp -vu ~/.xmonad/xmobarrc      ~/myarchconfig/
cp -vu ~/.xmonad/xmonad.hs     ~/myarchconfig/
cp -vu ~/.zshrc                ~/myarchconfig/zshrc
cp -vu ~/.zshrc.local          ~/myarchconfig/zshrc.local
cp -vu ~/bin/disp-controll     ~/myarchconfig/bin/
cp -vu ~/bin/myfsize.sh        ~/myarchconfig/bin/
cp -vu ~/.latexmkrc            ~/myarchconfig

echo
echo "git"
echo

git add .
git commit -a -m "aktualisiert"
git push
