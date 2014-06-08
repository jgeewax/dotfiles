# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# Add Ruby gem bin directory to the system path
PATH=/var/lib/gems/1.8/bin:$PATH

# Add home folder's bin to the system path
PATH=~/bin:$PATH

# Add the Android SDK's tools directory to the system path
PATH=/usr/local/android/tools:$PATH

# Add the go bin directory to the system path
PATH=/usr/local/go/bin:$PATH

# Add the lessc bin directory to the system path
PATH=~/node_modules/less/bin:$PATH

# Add Dart SDK to the system path
PATH=/opt/dart-sdk/bin:$PATH

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# Make the terminal by default xterm-256color
export TERM=xterm-256color

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  *)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Set up a local ssh-agent if necessary.
SSHAGENT=/usr/bin/ssh-agent
SSHAGENTARGS="-s"
SSHADDARGS="~/.ssh/id_rsa-jj@geewax.org"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
  eval `$SSHAGENT $SSHAGENTARGS`
  trap "kill $SSH_AGENT_PID" 0
fi

# Make the first call to SSH (on an empty agent) add the key to the agent.
ssh-add -l >/dev/null || \
  alias ssh="ssh-add -l >/dev/null || ssh-add $SSHADDARGS && unalias ssh; ssh"

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
  . /etc/bash_completion
fi

# Git stuff
get_branch() {
  git branch 2> /dev/null | grep \* | awk '{print "("$2")"}'
}

# Default PS1
#PS1="\[\033[01;34m\]\$(get_repository)\[\033[31m\]\$(get_branch)\[\033[37m\]\[\033[00m\]\[\033[38m\]\u@\h:\w$ "
PS1="\[\033[31m\]\$(get_branch)\[\033[37m\]\[\033[00m\]\[\033[38m\]\u@\h:\w$ "

# tmux attach utility (https://github.com/ryandotsmith/tat/)
export CODE_ROOT_DIRS=~/projects/:~/playground/
# Make sure the directories exist.
( IFS=:
  for d in $CODE_ROOT_DIRS; do
    mkdir -p $d
  done
)
tat() {
  local session_name="$1"
  local sessions=( $(tmux list-sessions 2>/dev/null | cut -d ":" -f 1 | grep "^$session_name$") )

  if [ ${#sessions[@]} -gt 0 ]; then
    # If there is already a session with the same name, attach to it.
    tmux attach-session -d -t "$session_name"
  else
    # If there is no existing session, create a new (detached) one.
    tmux new-session -d -s "$session_name"

    # Try to find a matching code directory.
    local code_root_dirs=$(echo $CODE_ROOT_DIRS | sed 's/:/ /g')
    local matching_dirs=( $(find $code_root_dirs -maxdepth 1 -name "$session_name" -type d ) )

    # If there is a matching directory, set it as the default path.
    if [ ${#matching_dirs[@]} -gt 0 ]; then
      local code_dir=${matching_dirs[0]}
      tmux set default-path "$code_dir" 1>/dev/null
      tmux send-keys -t "$session_name:1" "cd $code_dir && clear" C-m

      # Check if there is a .tmux file in this directory.
      if [ -f "$code_dir/.tmux" ]; then
        echo "there is a tmux file, executing"
        eval "$code_dir/.tmux" $session_name
      fi
    fi

    # Finally, attach to the newly created session.
    tmux attach-session -t "$session_name"
  fi
}

_tat() {
  COMPREPLY=()
  local session="${COMP_WORDS[COMP_CWORD]}"
  local code_root_dirs=$(echo $CODE_ROOT_DIRS | sed 's/:/ /g')
  local sessions=( $(compgen -W "$(tmux list-sessions 2>/dev/null | awk -F: '{ print $1 }')" -- "$session") )
  local directories=( $(
  for dir in $code_root_dirs; do
    cd "$dir" 2 >/dev/null && compgen -d -- "$session"
  done
  ) )
  COMPREPLY=( ${sessions[@]} ${directories[@]} )
}

complete -o filenames -o nospace -F _tat tat
