#!/bin/bash

# IMPORTANT - This script is meant to run on a clean fresh Arch install on physical hardware

# Define the softwares that will be installed
prep_stage=(
	qt5-wayland
	qt5ct
	qt6-wayland
	qt6ct
	qt5-svg
	qt5-quickcontrols2
	qt5-graphicaleffects
	gtk3
	polkit-gnome
	pipewire
	wireplumber
	jq
	gcc12
	wl-clipboard
	cliphist
	python-requests
	pacman-contrib
)

# Softwares for Nvidia GPU only
# nvidia_stage=(
# 	linux-headers
# 	nvidia-dkms
# 	nvidia-settings
# 	libva
# 	libva-nvidia-driver-git
# )

# The main packages
install_stage=(
	kitty
	mako
	waybar-hyprland
	swww
	swaylock-effects
	wofi
	wlogout
	xdg-desktop-portal-hyprland
	swappy
	grim
	slurp
	thunar
	btop
	google-chrome
	firefox
	thunderbird
	mpv
	pamixer
	pavucontrol
	brightnessctl
	bluez
	bluez-utils
	blueman
	network-manager-applet
	gvfs
	thunar-archive-plugin
	file-roller
	starship
	papirus-icon-theme
	ttf-jetbrains-mono-nerd
	noto-fonts-emoji
	lxappearance
	xfce4-settings
	nwg-look-bin
	sddm-git
)

for str in ${myArray[@]}; do
	echo $str
done

# Set some colors
CNT="[\e[1;36mNOTE\e[0m]"
COK="[\e[1;32mOK\e[0m]"
CER="[\e[1;31mERROR\e[0m]"
CAT="[\e[1;37mATTENTION\e[0m]"
CWR="[\e[1;35mWARNING\e[0m]"
CAC="[\e[1;33mACTION\e[0m]"
INSTLOG="install.log"

# Show a progress bar
show_progress() {
	while ps | grep $1 &>/dev/null; do
		echo -n "."
		sleep 2
	done
	echo -en "Done!\n"
	sleep 2
}

# Test for a package, and if not found, it will attempt to install it
install_software() {
	# See if the package is already installed
	if yay -Q $1 &>>/dev/null; then
		echo -e "$COK - $1 is already installed."
	else
		# If not, then install it
		echo -en "$CNT - Now installing $1 ."
		yay -S --noconfirm $1 &>>$INSTLOG &
		show_progress $!
		# Test to make sure the package is installed
		if yay -Q $1 &>>/dev/null; then
			echo -e "\e[1A\e[K$COK - $1 was installed."
		else
			# If this is hit, then a package is missing. Exit to review log
			echo -e "\e[1A\e[K$CER - $1 install has failed. Please, check the install.log"
			exit
		fi
	fi
}

# Clear the screen
clear

# Find the Nvidia GPU
# if lspci -k | grep -A 2 -E "(VGA|3D)" | grep -iq nvidia; then
# 	ISNVIDIA=true
# else
# 	ISNVIDIA=false
# fi

# Disable wifi powersave mode
read -rep $'[\e[1;33mACTION\e[0m] - Disable wifi powersave? (Y,n) ' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
	LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
	echo -e "$CNT - The following file has been created $LOC.\n"
	echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC &>>$INSTLOG
	echo -en "$CNT - Restarting NetworkManager service, Please wait."
	sleep 2
	sudo systemctl restart NetworkManager &>>$INSTLOG

	# Wait for services to restore (looking at DNS)
	for i in {1..6}; do
		echo -n "."
		sleep 1
	done
	echo -en "Done!\n"
	sleep 2
	echo -e "\e[1A\e[K$COK - NetworkManager restart completed."
fi

# Check for package manager
if [ ! -f /sbin/yay ]; then
	echo -en "$CNT - Configuring yay."
	git clone https://aur.archlinux.org/yay.git &>>$INSTLOG
	cd yay
	makepkg -si --noconfirm &>>../$INSTLOG &
	show_progress $!
	if [ -f /sbin/yay ]; then
		echo -e "\e[1A\e[K$COK - yay configured"
		cd ..

		# Update the yay database
		echo -en "$CNT - Updating yay."
		yay -Suy --noconfirm &>>$INSTLOG &
		show_progress $!
		echo -e "\e[1A\e[K$COK - yay updated."
	else
		# If this is hit, then a package is missing. Exit to review log
		echo -e "\e[1A\e[K$CER - yay install failed, please check the install.log"
		exit
	fi
fi

# Install all of the above packages
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to install the packages? (Y,n) ' INST
if [[ $INST == "Y" || $INST == "y" ]]; then

	# Prep stage
	echo -e "$CNT - Prep stage - Installing needed components, this may take a while..."
	for SOFTWR in ${prep_stage[@]}; do
		install_software $SOFTWR
	done

	# Setup Nvidia if it was found
	# if [[ "$ISNVIDIA" == true ]]; then
	# 	echo -e "$CNT - Nvidia GPU support setup stage, this may take a while..."
	# 	for SOFTWR in ${nvidia_stage[@]}; do
	# 		install_software $SOFTWR
	# 	done

	# Update config
	sudo sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
	sudo mkinitcpio --config /etc/mkinitcpio.conf --generate /boot/initramfs-custom.img
	echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf &>>$INSTLOG
fi

# Install the correct hyprland version
echo -e "$CNT - Installing Hyprland, this may take a while..."
if [[ "$ISNVIDIA" == true ]]; then
	# Check for hyprland and remove it so the -nvidia package can be installed
	if yay -Q hyprland &>>/dev/null; then
		yay -R --noconfirm hyprland &>>$INSTLOG &
	fi
	install_software hyprland-nvidia
else
	install_software hyprland
fi

# Fix needed for waybar-hyprland
export CC=gcc-12 CXX=g++-12

# Stage 1 - main components
echo -e "$CNT - Installing main components, this may take a while..."
for SOFTWR in ${install_stage[@]}; do
	install_software $SOFTWR
done

# Start the bluetooth service
echo -e "$CNT - Starting the Bluetooth Service..."
sudo systemctl enable --now bluetooth.service &>>$INSTLOG
sleep 2

# Enable the sddm login manager service
echo -e "$CNT - Enabling the SDDM Service..."
sudo systemctl enable sddm &>>$INSTLOG
sleep 2

# Clean out other portals
echo -e "$CNT - Cleaning out conflicting xdg portals..."
yay -R --noconfirm xdg-desktop-portal-gnome xdg-desktop-portal-gtk &>>$INSTLOG

# Copy config files
read -rep $'[\e[1;33mACTION\e[0m] - Would you like to copy config files? (Y,n) ' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
	echo -e "$CNT - Copying config files..."

	# Setup each application
	# Check for existing config folders and backup
	# for DIR in hypr kitty mako swaylock waybar wlogout wofi; do
	# 	DIRPATH=~/.config/$DIR
	# 	if [ -d "$DIRPATH" ]; then
	# 		echo -e "$CAT - Config for $DIR located, backing up."
	# 		mv $DIRPATH $DIRPATH-back &>>$INSTLOG
	# 		echo -e "$COK - Backed up $DIR to $DIRPATH-back."
	# 	fi
	#
	# 	# Make new empty folders
	# 	mkdir -p $DIRPATH &>>$INSTLOG
	# done

	# Link up the config files
	echo -e "$CNT - Setting up the new config..."

	ln -sf ~/hyprland-dotfiles/.config/hypr/ ~/.config/
	echo "Hyprland linked"

	ln -sf ~/hyprland-dotfiles/.config/kitty/ ~/.config/
	echo "Kitty linked"

	ln -sf ~/hyprland-dotfiles/.config/mako/ ~/.config/
	echo "Mako linked"

	ln -sf ~/hyprland-dotfiles/.config/swaylock/ ~/.config/
	echo "Swaylock linked"

	ln -sf ~/hyprland-dotfiles/.config/waybar/ ~/.config/
	echo "Waybar linked"

	ln -sf ~/hyprland-dotfiles/.config/wlogout/ ~/.config/
	echo "Wlogout linked"

	ln -sf ~/hyprland-dotfiles/.config/wofi/ ~/.config/
	echo "Wofi linked"

	# Add the Nvidia env file to the config (if needed)
	# if [[ "$ISNVIDIA" == true ]]; then
	# 	echo -e "\nsource = ~/.config/hypr/env_var_nvidia.conf" >>~/.config/hypr/hyprland.conf
	# fi

	# Setup the first look and feel as dark
	xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
	gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
	gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark"
fi

# Script is done
echo -e "$CNT - Installation is completed!"
# if [[ "$ISNVIDIA" == true ]]; then
# 	echo -e "$CAT - Since we attempted to setup an Nvidia GPU the script will now end and you should reboot.
#     Please type 'reboot' at the prompt and hit Enter when ready."
# 	exit
# fi

read -rep $'[\e[1;33mACTION\e[0m] - Would you like to start Hyprland now? (Y,n) ' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
	exec sudo systemctl start sddm &>>$INSTLOG
else
	exit
fi
