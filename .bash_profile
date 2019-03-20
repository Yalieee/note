# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

export PS1="\[\033[38;5;10m\]\A\[$(tput sgr0)\]\[\033[38;5;15m\] \W \\$ \[$(tput sgr0)\]"

gitfile() {
    git diff-tree --no-commit-id --name-only -r "$1"
}

alias ll="ls -al"
alias gclean="git branch --merged | egrep -v \"(^\*|master|dev)\" | xargs git branch -d"
export PATH="/usr/local/opt/php@7.2/bin:$PATH"
export PATH="/usr/local/opt/php@7.2/sbin:$PATH"
export PATH="/usr/local/opt/gettext/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"

export LC_ALL="en_US.UTF-8"
