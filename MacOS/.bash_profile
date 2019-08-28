alias ls='ls -G1'
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad 

alias gl="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20 --no-merges"
alias glm="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20"
alias gh="git log --graph --pretty=format:'%C(bold blue)%an%Creset %Cgreen%cr%Creset -%C(yellow)%d%Creset %s %Cred[%h]%Creset' --abbrev-commit --date=relative"
alias gs='git status'
alias gcf='git commit -m wip'
alias ga='git add .'
function gc(){ git commit -m "$1"; }
function gcn(){ git commit -m "$1" -n; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
