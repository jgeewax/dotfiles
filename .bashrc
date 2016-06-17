# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Add home folder's bin to the system path
PATH=~/bin:$PATH

# Add Ruby gem bin directory to the system path
PATH=/var/lib/gems/1.8/bin:$PATH

# Add the go bin directory to the system path
PATH=/usr/local/go/bin:$PATH

# Add Android stuff...
PATH=/opt/android/tools:/opt/android/platform-tools:$PATH
PATH=~/Android/Sdk/tools:~/Android/Sdk/platform-tools:$PATH
export ANDROID_HOME=~/Android/Sdk

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# less should scroll
export LESS=-R

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Make the terminal by default xterm-256color
export TERM=xterm-256color

if [ -f ~/.bash-powerline.sh ]; then
  . ~/.bash-powerline.sh
fi

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

if [ -f ~/.bash-tat.sh ]; then
  . ~/.bash-tat.sh
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Set up a local ssh-agent if necessary.
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
SSHADDARGS="~/.ssh/id_rsa"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi

# Make the first call to SSH (on an empty agent) add the key to the agent.
ssh-add -l >/dev/null || \
  alias ssh="ssh-add -l >/dev/null || ssh-add $SSHADDARGS && unalias ssh; ssh"

export PATH

# ===============

# added by travis gem
[ -f /usr/local/google/home/jjg/.travis/travis.sh ] && source /usr/local/google/home/jjg/.travis/travis.sh

export NVM_DIR="/usr/local/google/home/jjg/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# The next line updates PATH for the Google Cloud SDK.
source '/usr/local/google/home/jjg/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
source '/usr/local/google/home/jjg/google-cloud-sdk/completion.bash.inc'

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
