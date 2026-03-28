# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
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
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
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
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
alias vim='nvim'

export PATH="$JAVA_HOME/bin:$HOME/bin/OpenIDE:$HOME/bin:$HOME/.local/usr/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:$HOME/bin/apache-maven-3.8.6/bin:/mnt/c/Users/acken/AppData/Local/Programs/Microsoft VS Code/bin"

KEYTIMEOUT=1

TERM=xterm-256color

KEYMAPPROGRAM=$(which setxkbmap 2>/dev/null)

# Map caps lock to escape (only for real X11, not Wayland / XWayland)
if [[ -n "$DISPLAY" && -z "$WAYLAND_DISPLAY" && -n "$KEYMAPPROGRAM" ]]; then
    setxkbmap -option caps:escape
    xmodmap ~/.Xmodmap
    # Remap AltGr+ø/æ to ö/ä to match MD600 keyboard legends
    ~/src/dotfiles/fix-xkb-altgr.sh
fi

# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# make sure we can press ctrl+s in terminal and not end up pausing
stty -ixon

# Use vim key bindings in terminal
bindkey -v
bindkey '^R' history-incremental-search-backward

zstyle ':completion:*' special-dirs true

autoload bashcompinit
bashcompinit
[[ -f /etc/bash_completion.d/oi ]] && source /etc/bash_completion.d/oi

function mkcd() {
    mkdir -p "$1"
    cd "$1"
}

function new() {
    pwd | gnome-terminal
}

alias nexus-token='echo -n "Username: " && \
    read username && echo -n "Password (no OTP): " && \
    read -s password && echo && \
    echo -n "OTP (leave blank if disabled): " && \
    read -s otp && echo && \
    mkdir -p /tmp/ && \
    rm -f /tmp/nexus-token.sh &>/dev/null && \
    curl --silent -X POST https://aeu1-nexus01-token.publicdns.zone/auth \
    --data "{\"username\": \"$username\", \"password\": \"$password$otp\"}" \
    -H "Content-Type: application/json" > /tmp/nexus-token.sh && \
    chmod +x /tmp/nexus-token.sh && /tmp/nexus-token.sh; rm -f /tmp/nexus-token.sh'

[[ -f ~/.dircolors ]] && eval "$(dircolors ~/.dircolors)" || eval "$(dircolors)"

# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet



#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
fpath=($HOME/.zsh-completions $fpath)
autoload -U compinit
compinit


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end
#

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Android SDK
if [[ -d "$HOME/Android/Sdk" ]]; then
  export ANDROID_HOME=$HOME/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# .NET SDK
if [[ -d "$HOME/.dotnet" ]]; then
  export DOTNET_ROOT=$HOME/.dotnet
  export PATH=$PATH:$DOTNET_ROOT
fi
