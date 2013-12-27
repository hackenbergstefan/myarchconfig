#!/bin/sh
echo "creating directories"
echo
mkdir ~/bin
mkdir ~/.xmonad

echo "copy"
echo
cp -v  ~/myarchconfig/Xresources                 ~/.Xresources           
cp -v  ~/myarchconfig/aliasrc                    ~/.aliasrc              
cp -v  ~/myarchconfig/bash_profile               ~/.bash_profile         
cp -v  ~/myarchconfig/bashrc                     ~/.bashrc               
cp -v  ~/myarchconfig/tmux.conf                  ~/.tmux.conf            
cp -v  ~/myarchconfig/vimencrypt                 ~/.vimencrypt           
cp -v  ~/myarchconfig/vimrc                      ~/.vimrc                
cp -v  ~/myarchconfig/xinitrc                    ~/.xinitrc              
cp -v  ~/myarchconfig/xmobarrc                   ~/.xmonad/xmobarrc      
cp -v  ~/myarchconfig/xmonad.hs                  ~/.xmonad/xmonad.hs     
cp -v  ~/myarchconfig/zshrc.local                ~/.zshrc.local          
cp -v  ~/myarchconfig/bin/disp-controll          ~/bin/disp-controll     
cp -v  ~/myarchconfig/bin/myfsize.sh             ~/bin/myfsize.sh        

