
#Don't use this if you don't know the packages!
#
pacman -Sy
pacman -S xorg-server xorg-xinit xorg-server-utils xorg-twm awesome terminator vicious virtualbox-guest-modules virtualbox-guest-utils alsa-utils wireless_tools xcompmgr conky terminus-font

#setting up conky
cp .conkyrc ~/.conkyrc

#hddtemp: for the HDD Temp widget type
#alsa-utils: for the Volume widget type
#wireless_tools: for the Wireless widget type
#curl: for widget types accessing network resources
