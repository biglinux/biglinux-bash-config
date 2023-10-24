# -------------------------------------------------
# .bashrc Configuration
# -------------------------------------------------

# ----- PATH Configuration -----
# Add custom and standard binary locations to PATH
PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/usr/games:/sbin:$HOME/bin:$HOME/.local/bin"

# Only apply settings if bash is running interactively
case $- in
    *i*) ;;
    *) return;;
esac

# ----- Color Support & Aliases -----
# Enable color support and set related aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
fi

# More ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Load Blesh for enhanced interactive shell experience
if [[ -f /usr/share/blesh/ble.sh ]] && [[ ! -f ~/.bash-normal ]] && [[ $TERM != linux ]]; then
    source /usr/share/blesh/ble.sh --noattach
    #GRC Configuration for colorizing command outputs
    #GRC_ALIASES=true
    #GRC="/usr/bin/grc"
    #if tty -s && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && [ -n "$GRC" ]; then
    #    alias colourify="$GRC -es"
    #    alias blkid='colourify blkid'
    #    alias configure='colourify ./configure'
    #    alias df='colourify df'
    #    alias diff='colourify diff'
    #    alias docker='colourify docker'
    #    alias docker-compose='colourify docker-compose'
    #    alias docker-machine='colourify docker-machine'
    #    alias du='colourify du'
    #    alias env='colourify env'
    #    alias free='colourify free'
    #    alias fdisk='colourify fdisk'
    #    alias findmnt='colourify findmnt'
    #    alias make='colourify make'
    #    alias gcc='colourify gcc'
    #    alias g++='colourify g++'
    #    alias id='colourify id'
    #    alias ip='colourify ip'
    #    alias iptables='colourify iptables'
    #    alias as='colourify as'
    #    alias gas='colourify gas'
    #    # alias journalctl='colourify journalctl'
    #    alias kubectl='colourify kubectl'
    #    alias ld='colourify ld'
    #    # alias ls='colourify ls'
    #    alias lsof='colourify lsof'
    #    alias lsblk='colourify lsblk'
    #    alias lspci='colourify lspci'
    #    alias netstat='colourify netstat'
    #    alias ping='colourify ping'
    #    alias ss='colourify ss'
    #    alias traceroute='colourify traceroute'
    #    alias traceroute6='colourify traceroute6'
    #    alias head='colourify head'
    #    alias tail='colourify tail'
    #    alias dig='colourify dig'
    #    alias mount='colourify mount'
    #    alias ps='colourify ps'
    #    alias mtr='colourify mtr'
    #    alias semanage='colourify semanage'
    #    alias getsebool='colourify getsebool'
    #    alias ifconfig='colourify ifconfig'
    #    alias sockstat='colourify sockstat'
    #fi

    # Color settings for GCC outputs
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # Use bat for cat if available
    if [ -f /usr/bin/bat ]; then
        alias cat='bat --paging=never --style=numbers'
    fi

    # eza Configuration for enhanced directory listings
    # if [ -f /usr/bin/eza ]; then
    #     alias ls='eza --icons --group-directories-first'                               # ls
    #     alias l='eza -lbF --git --icons--group-directories-first'                      # list, size, type, git
    #     alias ll='eza -lbGF --git --icons--group-directories-first'                    # long list
    #     alias llm='eza -lbGF --git --sort=modified --icons'                            # long list, modified date sort
    #     alias la='eza -lbhHigUmuSa --time-style=long-iso --git --color-scale --icons'  # all list
    #     alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --icons' # all + extended list
    # 
    #     # speciality views
    #     alias lS='eza -1 --icons'			                                            # one column, just names
    #     alias lt='eza --tree --level=2 --icons'                                         # tree
    # fi
fi

# ----- History Configuration -----
HISTCONTROL=ignoreboth  # Prevent saving commands that start with a space and duplicates
shopt -s histappend     # Append history rather than overwrite
HISTSIZE=1000           # Store up to 1000 commands in memory
HISTFILESIZE=2000       # Store up to 2000 commands in history file
shopt -s checkwinsize   # Automatically adjust window size after each command

# Load custom aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Auto completion Configuration
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# ----- NVM Configuration -----
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# FZF Configuration
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    _ble_contrib_fzf_base=/usr/share/fzf/
    . /usr/share/fzf/completion.bash
    . /usr/share/fzf/key-bindings.bash
fi

# Attach Blesh if available
if [[ ${BLE_VERSION-} ]]; then
    ble-attach
else
    # tty
    if [[ $TERM = linux ]]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        # bash-normal
        greenBg="\[\e[48;5;115m\]"
        greenFg="\[\e[38;5;115m\]"

        blackFg="\[\e[30m\]"
        whiteFg="\[\e[37m\]"

        # Reset
        fmtReset="\[\e[0m\]"

        systemBg="\[\e[48;5;237m\]"
        systemFg="\[\e[38;5;237m\]"

        nameBg="\[\e[48;5;248m\]"
        nameFg="\[\e[38;5;248m\]"

        # one line PS1
        PS1="$systemBg$greenFg   $systemFg$greenBg $blackFg$greenBg\w $fmtReset$greenFg$fmtReset "
    fi
fi
