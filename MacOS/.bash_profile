export PATH=$PATH:./node_modules/.bin
alias ls='ls -G1'
export CLICOLOR=1
export LSCOLORS=Gxfxcxdxbxegedabagacad 

alias gl="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20"
alias glnm="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20 --no-merges"
alias gh="git log --graph --pretty=format:'%C(bold blue)%an%Creset %Cgreen%cr%Creset -%C(yellow)%d%Creset %s %Cred[%h]%Creset' --abbrev-commit --date=relative"
alias gs='git status'
alias gcf='git commit -m wip'
alias ga='git add .'
alias gbmy="git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(authorname) %(refname:short)' | grep Nimish"
alias gb="git branch -v --sort=-committerdate"

function gc(){ git commit -m "$1"; }
function gcn(){ git commit -m "$1" -n; }
function youtubeflac(){ youtube-dl -x --audio-format flac "$1"; }
function youtubeaac(){ youtube-dl -x --audio-format aac "$1"; }
function youtubemp4(){ youtube-dl --format mp4 "$1"; }
function deletebranchesmatching(){ git branch -D `git branch | grep "$1"`; }

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# source ~/.bash_profile
