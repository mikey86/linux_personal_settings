## .BASHRC
#
# version: 20161101
#
# author: mikey86
#
#
# ==============================================================================

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# pokud je shell neinteraktivni, nic nedela a skonci
case $- in
    *i*) ;;
      *) return;;
esac

# ==============================================================================

# nastaveni barvy username v promptu podle uid
# ------------------------------------------------------------------------------

# RED           = 31
# GREEN         = 32
# YELLOW        = 33
# BLUE          = 34
# MAGENTA       = 35
# CYAN          = 36
# LIGHT GRAY    = 37
# DARK GREY     = 90
# LIGHT RED     = 91
# LIGHT GREEN   = 92
# LIGHT YELLOW  = 93
# LIGHT BLUE    = 94
# LIGHT MAGENTA = 95
# LIGHT CYAN    = 96
# WHITE         = 97

root_color="91"
user_color="93"

# pokud je root, nastavi mu jeho barvu
if [ $UID -eq 0 ]; then
    user_color=$root_color
fi

# ==============================================================================

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTTIMEFORMAT='%Y-%m-%d_%H:%M:%S; '
export HISTSIZE=100000
export HISTFILESIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[${user_color};1m\]\u\[\033[90;1m\]@\h:\[\033[34;1m\]$(branchname 2>/dev/null)\[\033[32m\]\w\[\033[0m\]\$ '
    PS2='\[\033[90;1m\]>\[\033[0m\]'
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

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -laFh'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -d ~/.bash_aliases.d ]; then
    for i in `ls ~/.bash_aliases.d`; do
        . ~/.bash_aliases.d/$i
    done
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

# pokud je nainstalovan vim, nastavi ho jako vychozi editor
if [ -f /usr/bin/vim ]; then
    export EDITOR='vim'
fi

export TERM=xterm-256color
