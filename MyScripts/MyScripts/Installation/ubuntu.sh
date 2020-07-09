mkdir .output
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install i3 git stow rofi curl python3-pip mlocate
git clone https://github.com/niccle27/Dotfiles
cd Dotfiles/
stow dunst
stow i3
stow zsh
stow rofi
stow ranger
stow Xorg
stow zathura
stow MyScripts/
cd ~
git clone https://github.com/niccle27/.emacs.d
sudo apt-get install -y  emacs zsh

chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd Dotfiles
stow oh-my-zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
# sudo apt-get update \nsudo apt-get install dropbox
# sudo apt-get update \nsudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
# sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E
# sudo apt-get update \nsudo apt-get install dropbox
# dropbox start -i &
# ln -s /home/niccle27/Dropbox/Org Org
# ln -s /home/niccle27/Dropbox/Notes Notes

# sudo apt-get install gimp blender audacity inkscape openshot
