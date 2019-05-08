alias ls='ls -G'
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad 

alias gl="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20"
alias gs='git status'
function gc(){ git commit -m "$1"; }
function gcn(){ git commit -m "$1" -n; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

