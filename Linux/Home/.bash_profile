#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

alias gl="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(green)%cn %<(20)%C(bold green)%an %Creset%C(blue)%ad %C(bold blue)%cd %C(cyan)%s' --date=format:'%Y %a %b %d %H:%M' -20"
alias glnl="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(green)%cn %<(20)%C(bold green)%an %Creset%C(blue)%ad %C(bold blue)%cd %C(cyan)%s' --date=format:'%Y %a %b %d %H:%M'"
alias glnm="git log --pretty=format:'%C(green)%h %C(yellow)%<(20)%cr %<(20)%C(bold green)%an %Creset%C(cyan)%s' -20 --no-merges"
alias gh="git log --graph --pretty=format:'%C(bold blue)%an%Creset %Cgreen%cr%Creset -%C(yellow)%d%Creset %s %Cred[%h]%Creset' --abbrev-commit --date=relative"
alias gs='git status'
alias gcw='git commit -m wip -n'
alias ga='git add .'
alias gbmy="git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(authorname) %(refname:short)' | grep Nimish"
alias gb="git branch -v --sort=-committerdate"
alias grm="git rebase master"
alias gsaf="git ls-files -o"

function gc(){ git commit -m "$1"; }
function gcn(){ git commit -m "$1" -n; }
function gr(){ git rebase -i HEAD~"$1"; }
function gsf(){ git show --pretty="format:" --name-only $1; }

function showMimeType() { file -i "$1"; }
function showDefaultApp() { xdg-mime query default "$1"; }
function setDefaultApp() { xdg-mime default "$2" "$1"; }

alias vpn=protonvpn-cli
alias enableKillSwitch='protonvpn-cli ks --permanent'
alias disableKillSwitch='protonvpn-cli ks --on'

alias cdSystemFonts='cd /usr/local/share/fonts'
alias cdFlatpakExports='cd ~/.local/share/flatpak/exports/share/applications'
alias cdConfig='cd ~/.config'
alias cdAutostart='cd /etc/xdg/autostart'

alias pauseNotifications='dunstctl set-paused true'
alias reloadProfile='source ~/.bash_profile'

alias steammin='steam -no-browser steam://open/minigameslist'
alias showDiskUsage='gdu -i /media,/proc,/dev,/sys,/run'

alias convertEpubs='for file in *.epub; do ebook-convert "${file}" "${file%}.htmlz"; done'
alias extractZips='for file in *.zip; do unzip -d "${file%.zip}" "$file"; done'
alias extractHtmlzs='for file in *.htmlz; do unzip -d "${file%.htmlz}" "$file"; done'

export VISUAL=nvim
export EDITOR=nvim
export HISTCONTROL=ignorespace:erasedups

# export NNN_USE_EDITOR=1
BLK="0B" CHR="0B" DIR="07" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
#BLK="0B" CHR="0B" DIR="07" EXE="01" REG="07" HARDLINK="06" SYMLINK="A4" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="5D"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

