# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/opt/homebrew/bin:/opt/homebrew/opt/node@22/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/chris/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="friskier"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git gem bundler golang npm rbenv ruby vi-mode yarn nvm zsh-nvm zsh-autosuggestions sd)

source $ZSH/oh-my-zsh.sh
source ${HOME}/.bash_aliases

# Set up so that 'shift-tab' does file completion, ignoring current context.
zle -C complete complete-word complete-files
bindkey '^[[Z' complete
complete-files () { compadd - $PREFIX* }

# push-line binding
bindkey '^u' push-line

# set up forward-word
bindkey '^g' forward-word

# Set up for autosuggest-execute
bindkey '^o' autosuggest-execute

# Set up zmv
autoload -U zmv

unsetopt autopushd

# User configuration
export EDITOR=/usr/bin/vi
export PATH=/usr/local/bin:/usr/local/sbin:$PATH:${HOME}/bin

# Set up for ripgrep config
export RIPGREP_CONFIG_PATH=/Users/chris/.config/ripgrep/config.rc

# Add rust
export PATH=$PATH:/Users/chris/.cargo/bin
export RUST_SRC_PATH=/Volumes/Second/Chris/hacks/rust/rust/src
export CARGO_HOME=/Users/chris/.cargo

# Add go
export GOPATH=/Users/chris/go
export PATH=${PATH}:${GOPATH}/bin

# fuzzy history search
# bindkey '^R'  fzy-history-widget

# Set up zoxide
eval "$(zoxide init zsh)"

# broot
# source /Users/chris/.config/broot/launcher/bash/br

# Fix for terminal double-characters in tmux
export TERM=xterm-256color

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# source /Users/chris/.docker/init-zsh.sh || true # Added by Docker Desktop
eval "$(atuin init zsh)"

# Added by `rbenv init` on Tue Dec  3 20:58:18 EST 2024
eval "$(rbenv init - --no-rehash zsh)"

# Added by Windsurf
export PATH="/Users/chris/.codeium/windsurf/bin:$PATH"
