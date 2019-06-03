case $- in
    *i*) ;;
      *) return;;
esac

export LANG="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

HISTCONTROL=ignoreboth
HISTSIZE=2000
HISTFILESIZE=3000

shopt -s histappend
shopt -s checkwinsize

case "${TERM}" in
    xterm-color|*-256color) color_prompt=yes;;
esac

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Aliases

alias ls="ls --group-directories-first --color=always -h"
alias cd..="cd .."
alias ..='cd ..'
alias ...='cd ../..'
alias -- -="cd -"

alias grep='grep --color=auto'

# set PATH so it includes project's private bin

export PATH="/app/bin:$PATH"
