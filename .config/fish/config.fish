if status is-interactive
    # Commands to run in interactive sessions can go here
end
eval ($HOME/.linuxbrew/bin/brew shellenv)

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# force fish to use the default prompt
source $XDG_CONFIG_HOME/fish/functions/fish_prompt.fish

alias vim=nvim
alias claude="/var/home/alex/distrobox/ninjanerd/.claude/local/claude"
