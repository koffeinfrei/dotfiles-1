# Check for interactive bash and fzf
[ -n "$BASH_INTERACTIVE" ] && has fzf || return

export FZF_TMUX=0
export FZF_DEFAULT_COMMAND="fdfind --hidden --ignore-file /etc/dotfiles/ignore --color always --type f"
export FZF_DEFAULT_OPTS="--ansi --multi --filepath-word --inline-info --layout default --no-height --prompt '» ' --bind '?:toggle-preview'"
export FZF_COMPLETION_TRIGGER='//'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type d --type l"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND/--type f/--type d}"

export FZF_CTRL_R_OPTS="--preview 'echo {} | cut -d\  -f4-' --preview-window up:3:hidden:wrap"
export FZF_ALT_C_OPTS="--preview 'tree -C {}' --preview-window hidden"

_fzf_compgen_path() { $FZF_CTRL_T_COMMAND; }
_fzf_compgen_dir() { $FZF_ALT_C_COMMAND; }

. /usr/share/bash-completion/completions/fzf
. /usr/share/doc/fzf/examples/key-bindings.bash

_fzf_orig_completion_ping='_ssh'
_fzf_orig_completion_telnet='_ssh'
_fzf_orig_completion_host='_ssh'
_fzf_orig_completion_nc='_ssh'
_fzf_orig_completion_curl='_ssh'

complete -F _fzf_complete_ssh ping telnet host nc curl
complete -o bashdefault -o default -F _fzf_path_completion rg
