case $- in
    *i*) ;;
      *) return;;
esac

shopt -s histappend
shopt -s checkwinsize

stty -ixon

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000

# If set, the pattern "**" used in a pathname expansion context will match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ `id -u` != "0" ]; then
	PS1='\[\033[38;5;69;48;5;17m\] \u@\h \[\033[00m\]\[\033[38;5;214;48;5;52m\] \w \[\033[00m\] '
else
	PS1='\[\033[38;5;0;48;5;124m\] \u@\h \[\033[00m\]\[\033[38;5;214;48;5;52m\] \w \[\033[00m\] '
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# If the .xsession-errors file is not a symbolic link, delete it and create it as such
if [ ! -h $HOME/.xsession-errors ]; then
	/bin/rm $HOME/.xsession-errors
	ln -s /dev/null $HOME/.xsession-errors
fi

export PATH="$PATH:/usr/local/go/bin:~/.local/bin:$HOME/.bun/bin"

export GTK2_RC_FILES=/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc
export GTK_THEME=Adwaita:dark
export VISUAL=micro
export EDITOR=micro
export MICRO_TRUECOLOR=1
export SDCV_HISTSIZE=0
export GREP_COLORS='mt=1;33:fn=35:ln=32'
export RIPGREP_CONFIG_PATH=~/.config/rg/.ripgreprc
export HTML_TIDY=~/.config/tidy/tidy.cfg
export RANGER_LOAD_DEFAULT_RC=FALSE

#																		#
#	begin colors in man pages											#
#																		#

export MANPAGER="less -R --use-color -Dd166.- -Du70.- -DS208.52 -Ds190.- -DP1.- -DE208.52-"
export MANROFFOPT="-c"

#																		#
#	end colors in man pages												#
#																		#

if [ -f /home/main/.bash_aliases ]; then
	. /home/main/.bash_aliases
fi

if [ -f /home/main/.bash_functions ]; then
	. /home/main/.bash_functions
fi
