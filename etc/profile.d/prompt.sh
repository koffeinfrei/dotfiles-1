# Check for interactive bash
[ -n "$BASH_INTERACTIVE" ] || return

# Prompt configuration

# colors
_reset='\[\e[0m\]'           # Reset

# regular
_black='\[\e[0;30m\]'        # Black
_red='\[\e[0;31m\]'          # Red
_green='\[\e[0;32m\]'        # Green
_yellow='\[\e[0;33m\]'       # Yellow
_blue='\[\e[0;34m\]'         # Blue
_purple='\[\e[0;35m\]'       # Purple
_cyan='\[\e[0;36m\]'         # Cyan
_white='\[\e[0;37m\]'        # White

# bold
_bblack='\[\e[1;30m\]'       # Black
_bred='\[\e[1;31m\]'         # Red
_bgreen='\[\e[1;32m\]'       # Green
_byellow='\[\e[1;33m\]'      # Yellow
_bblue='\[\e[1;34m\]'        # Blue
_bpurple='\[\e[1;35m\]'      # Purple
_bcyan='\[\e[1;36m\]'        # Cyan
_bwhite='\[\e[1;37m\]'       # White

[ -n "$CONQUE" ] && unset _bblack

PS1_USER="\u"
PS1_HOST=""
[ -n "$SSH_CONNECTION" -o "$TERM" = "linux" ] && PS1_HOST="@\h"
[ "$UID" = "0" ] && PS1_USER="$_bred$PS1_USER"

export PS1="$_reset$_bblack$PS1_USER$_byellow$PS1_HOST $_cyan[$_bcyan\w$_cyan]$_reset \[\$(_ps1_exit_code)\]"

function _ps1_exit_code {
  local status=$?
  [ -n "$CYGWIN" -o "$CONQUE" ] && return

  tput sc
  if [ $status -gt 0 ]; then
    tput cup $LINES $((COLUMNS-5-${#status}))
    printf '  \033[1;30m[\033[1;31m%s\033[1;30m]\033[0m ' "$status"
  else
    tput cup $LINES $((COLUMNS-9))
    printf '        '
  fi
  tput rc
}

# Use Git prompt if available
if type __git_ps1 &>/dev/null; then
  export GIT_PS1_SHOWDIRTYSTATE=1
  export GIT_PS1_SHOWSTASHSTATE=1
  export GIT_PS1_SHOWUNTRACKEDFILES=1
  export GIT_PS1_SHOWUPSTREAM='auto git'

  GIT_PS1_SUBSTITUTES="
    s/=//;
    s/<>/ ⇵/;
    s/>/ ↑/;
    s/</ ↓/;
  "

  export GIT_PS1='$(__git_ps1 "\[\e[0;32m\][\[\e[1;32m\]%s\[\e[0;32m\]]\[\e[0m\] " | sed "$GIT_PS1_SUBSTITUTES")'
  export SUDO_PS1=$PS1
  export PS1=$PS1$GIT_PS1
fi

# Set window titles when displaying prompt
if [[ "$TERM" =~ ^(rxvt|xterm-256color|screen-) ]]; then
  if [ -n "$SSH_CONNECTION" ]; then
    _hostname="$USER@$HOSTNAME:"
  else
    unset _hostname
  fi

  if [ -n "$STY" -o -n "$TMUX" ]; then
    export PROMPT_COMMAND='[ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD";_pwd=${PWD/$HOME/\~}; echo -ne "\033]0;'$_hostname'$_pwd\007\033k$_pwd\033\\"'
  else
    export PROMPT_COMMAND='_pwd=${PWD/$HOME/\~}; echo -ne "\033]1;'$_hostname'$_pwd\007\033]2;'$_hostname'$_pwd\007"'
  # else
  #   export PROMPT_COMMAND='_pwd=${PWD/$HOME/\~}; echo -ne "\033]1;$_pwd\007\033]2;$_pwd\007"'
  fi

  unset _hostname
fi
