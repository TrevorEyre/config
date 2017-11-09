# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# History size
HISTSIZE=1000
HISTFILESIZE=2000

# Append to the history file, don't overwrite it
shopt -s histappend

# Check the window size after each command and resize if necessary
shopt -s checkwinsize

# Detect OS.
# Reference: https://stackoverflow.com/questions/3466166
if [[ $(uname -s) == Darwin* ]]; then
    OS="mac"
elif [[ $(uname -s) == Linux* ]]; then
    OS="linux"
elif [[ $(uname -s) == MINGW* ]]; then
    OS="windows"
elif [[ $(uname -s) == CYGWIN* ]]; then
    OS="windows"
elif [[ $(uname -s) == MSYS* ]]; then
    OS="windows"
fi

# Extend path
if [ "$OS" = windows ]; then
    # MSBuild (Visual Studio 2017)
    export PATH=$PATH:"/c/Program Files (x86)/Microsoft Visual Studio/2017/Enterprise/MSBuild/15.0/Bin"
    # IIS Express
    export PATH=$PATH:"/c/Program Files/IIS Express"
fi

# Aliases
alias ll='ls -al'
alias la='ls -A'
alias l='ls -C'
# Enable color support of ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
# For commiting config files to git repo
alias config="git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Color variables
GREEN='\[\033[01;32m\]'
BLUE='\[\033[01;34m\]'
ENDCOLOR='\[\033[00m\]'

# Get git branch if in git repository
get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

# Set a fancy prompt
case "$TERM" in
    xterm-color) COLOR=yes;;
esac

# Detect color support
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    COLOR=yes
else
    COLOR=
fi

# Set prompt. Ex: /working/directory [git-branch] >
if [ "$COLOR" = yes ]; then
    PS1="$BLUE\w$GREEN\$(get_git_branch)$BLUE > $ENDCOLOR"
else
    PS1="\w\$(get_git_branch) > "
fi
unset COLOR
