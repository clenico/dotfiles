# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="xxf"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%d/%m/%y %H:%M"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    zsh-syntax-highlighting
	zsh-autosuggestions
    docker
    docker-compose
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias nf="neofetch"
alias ll="ls -larth"
alias tb="taskbook"
alias tson="xinput -enable \"Atmel\""
alias tsoff="xinput -disable \"Atmel\""
alias backupDotFiles="~/MyScripts/Sys/backupDotfiles.sh"
alias radoc="ranger ~/Documents"
alias radow="ranger ~/Downloads/"
alias rasch="ranger ~/School/"
alias radrop="ranger ~/Dropbox/"

# Location
alias tmp="cd  /tmp/"
alias opt="cd  /opt/"
alias doc="cd  ~/Documents/"
alias dow="cd  ~/Downloads/"
alias dot="cd  ~/Dotfiles/"
alias mnt="cd  /mnt/"
alias proj="cd  ~/Documents/Projects/"
alias td="cd  ~/Documents/Projects/Todo/"
alias di="cd  ~/Documents/Projects/Doing/"
alias dn="cd  ~/Documents/Projects/Done/"

alias ranloc='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias rl='ranloc'
alias hist="history"
alias python="python3"
alias pip="pip3"
alias pip2="/usr/bin/pip"
alias ec="emacsclient"
alias r="ranger"
alias ubuntu="docker run -it --rm mubuntu"
alias centos="docker run -it --rm centos bash"
alias gc="git clone "
alias tt="touch "
alias psg="ps -aux | grep"
alias mm="mkdir build && cd build && cmake .. && make"
alias da="deactivate"
alias jn="jupyter notebook"
alias dtp="cd ~/Documents/Tmp/"
alias hist="history"

alias auu="sudo apt-get -y update && sudo apt-get -y upgrade "
alias au="sudo apt-get -y update "
alias ai="sudo apt-get install "
alias arm="sudo apt remove "
alias aarm="sudo apt autoremove "
alias pwc="pwd | xclip -selection c"



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib6
export PATH=$PATH:/usr/local/cuda/bin
export PATH=$PATH:"$HOME/MyScripts/"
# Fix completion git and docker
autoload -Uz compinit
compinit

export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source $HOME/.local/bin/virtualenvwrapper.sh

ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
