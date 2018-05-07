# ~/.bashrc: executed by bash(1) for non-login shells.

export LESS='-q'
export EDITOR=vim

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='-G'
export HISTCONTROL=ignoredups
#eval `dircolors`
alias ls='ls $LS_OPTIONS'
alias l='ls $LS_OPTIONS -Fahl'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias gg='git grep'

if [ `id -u` -eq 0 ]; then
  export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/usr/bin/X11:/usr/games"
fi
# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
   PATH=~/bin:"${PATH}"
fi
# set PATH so it includes user's private bin if it exists
if [ -d ~/.bin ] ; then
   PATH=~/.bin:"${PATH}"
fi

if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# git svn externals
alias git-co-externals='git svn show-externals | grep "^/" | sed "s|^/\([^ ]*\)\(.*\) \(.*\)|(mkdir -p \1 \&\& cd \1 \&\& if [ -d .svn ]; then echo \"svn up \2 \1\" \&\& svn up \2 ; else echo \"svn co \2 \3 \1\" \&\& svn co \2 \3 . ; fi)|" | sh'

export LESS='-XFR'

# 256 colors
if [[ ${TMUX} == '' ]]
then
    export TERM="xterm-256color"
else
    export TERM="screen-256color"
fi

if [ -f ~/.bashrc_after ]; then
    source ~/.bashrc_after
fi

if which brew >/dev/null; then
    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1)\$ '
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# ensure $SSH_AUTH_SOCK is available at /tmp/ssh-agent-$USER-screen
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != "/tmp/ssh-agent-$USER-screen" ]
then
    rm -f /tmp/ssh-agent-$USER-screen
    ln -sf "$SSH_AUTH_SOCK" "/tmp/ssh-agent-$USER-screen"
fi

# webcam capture
alias webcamshot='vlc -I dummy v4l2:///dev/video0 --video-filter scene --no-audio --scene-path . --scene-prefix image_prefix --scene-format png vlc://quit --run-time=1'

export PYTHONSTARTUP=~/.pythonrc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$PATH:$(npm bin)"
