# ZSH Configuration

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE

# Enable completion
autoload -Uz compinit
compinit

# Key bindings
bindkey -e  # Emacs key bindings

# Aliases
alias apagar="shutdown 0"
alias nv="nvim"
alias py="python"

# Git aliases
alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"

# Utilities
alias ls="ls -l --color=auto"
alias la="ls -la --color=auto"
alias c="clear"
alias ll="ls -alF"
alias grep="grep --color=auto"

# Development aliases
alias ns="nix-shell"

# Enable color support
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# Set default editor
export EDITOR=nvim

# Path additions (adjust as needed)
export PATH="$HOME/.local/bin:$PATH"

# Enable completion for various tools
if command -v fzf >/dev/null; then
    eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null; then
    eval "$(zoxide init zsh)"
fi

# Load plugins (install manually or via your package manager)
# For Arch Linux, install via AUR or pacman:
# - zsh-autosuggestions
# - zsh-syntax-highlighting
# - zsh-powerlevel10k

# Autosuggestions
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Powerlevel10k
if [ -f /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]; then
    source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
