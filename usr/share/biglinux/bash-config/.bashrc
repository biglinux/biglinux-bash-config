# -------------------------------------------------
# .bashrc Configuration
# -------------------------------------------------

# ---------------- PATH Configuration ----------------
# Add custom and standard directories to PATH for command execution
PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/usr/games:/sbin:$HOME/bin:$HOME/.local/bin"

# Apply the following settings only if the shell is interactive
case $- in
    *i*) ;;  # Continue if interactive
    *) return ;;  # Exit if not interactive
esac

# ---------------- Terminal Integration ----------------
# Many terminal emulators use VTE to display the current folder in the tab
if [[ "$TERM" != linux ]]; then
    __vte_osc7 () {
        printf "\033]7;file://%s%s\033\\" "$HOSTNAME" "$PWD"
    }
    PROMPT_COMMAND+=(__vte_osc7)
else
    tty-colorscheme one-half-black
    setfont /usr/share/kbd/consolefonts/ter-v22b.psf.gz
fi

# ---------------- Color Support & Aliases ----------------
# Enable color support for commands and define useful aliases
# Start before blesh to use lscolors inner blesh
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "${ dircolors -b ~/.dircolors; }" || eval "${ dircolors -b; }"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    # Highlight "other-writable" directories
    LS_COLORS+=':ow=01;33'
fi

# ---------------- ble.sh Configuration ----------------
# Load ble.sh for an improved interactive shell experience
if [[ -f /usr/share/blesh/ble.sh ]] && [[ ! -f ~/.bash-normal ]] && [[ -z $TERM_PROGRAM ]]; then
    # Fix cache if using an old snapshot with a new ble.sh cache
    if grep -q -m1 _ble_decode_hook ~/.cache/blesh/*/decode.bind.*.bind; then _bleCacheVersion=new; else _bleCacheVersion=old; fi
    if grep -q -m1 _ble_decode_hook /usr/share/blesh/lib/init-bind.sh; then _bleInstalledVersion=new; else _bleInstalledVersion=old; fi
    [[ $_bleInstalledVersion != $_bleCacheVersion ]] && rm ~/.cache/blesh/*/[dk]*
    
    if [[ -n $TERM_PROGRAM ]]; then
        source /usr/share/blesh/ble.sh --rcfile /etc/bigblerc
    else
        source /usr/share/blesh/ble.sh --attach=attach --rcfile /etc/bigblerc
    fi
    # FZF configuration for ble.sh
    if [ -f /usr/share/fzf/key-bindings.bash ]; then
        _ble_contrib_fzf_base=/usr/share/fzf/
    fi
else
    runttyPS1() {
        # Colors
        reset="\001\033[0m\002"
        redFg="\001\033[31m\002"
        greenFg="\001\033[32m\002"
        blueFg="\001\033[38;5;81m\002"
        yellowFg="\001\033[33m\002"
        # ===========================
        # VIRTUAL ENVIRONMENT STATUS
        # ===========================
        if [[ -n $VIRTUAL_ENV ]]; then
            echo -en " venv"
        fi

        # ===========================
        # GIT STATUS 
        # ===========================
        # Check if inside a Git repository and not in GVFS or Kio
        if [[ ! "$PWD" =~ ($UID/(gvfs|kio-fuse)) ]] && git rev-parse --is-inside-work-tree &>/dev/null; then

            # Get branch information
            branch=${ git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --exact-match 2>/dev/null; }
            
            if [ -n "$branch" ]; then
                # Parse Git status efficiently
                status=${ git status --porcelain=v2 2>/dev/null; }
                staged=0 modified=0 untracked=0
                
                staged=${ grep -c '^1 .M' <<<"$status"; }
                modified=${ grep -c '^1 M' <<<"$status"; }
                untracked=${ grep -c '^? ' <<<"$status"; }
                
                # Build Git prompt section
                gitPrompt="$blueFg  $branch"
                [[ $staged -gt 0 ]] && gitPrompt+="$greenFg  $staged"      # green
                [[ $modified -gt 0 ]] && gitPrompt+="$yellowFg  $modified"    # yellow
                [[ $untracked -gt 0 ]] && gitPrompt+="$redFg  $untracked"   # red
                gitPrompt+="$reset"
                echo -en "$gitPrompt "
            fi
        fi
    }

    setttyPS1() {
        echo -e "\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\${ runttyPS1; }\[\033[0m\]\$"
    }
    
    PS1="${ setttyPS1; } "
    
    # Prevents the vscode agent from using the true command to bypass error output checking
    if [[ "$TERM_PROGRAM" = "vscode" ]]; then
        alias true="false"
    fi
fi

# Additional 'ls' aliases for convenience
alias ll='ls -l'   # Long listing format
alias la='ls -A'   # Show all entries except '.' and '..'
alias l='ls -CF'   # Classify entries and display directories with a trailing slash

# ---------------- Advanced Customizations ----------------
if [[ $BLE_VERSION ]]; then
    # ----- Pyenv Configuration -----
    # Automatically activate pyenv if installed
    if command -v pyenv >/dev/null; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "${ pyenv init --path; }"
        eval "${ pyenv init -; }"
    fi

    # ----- GRC-RS Configuration -----
    # Enable colorized output for various commands using grc-rs
    GRC="/usr/bin/grc-rs"
    if tty -s && [ -n "$TERM" ] && [ "$TERM" != "dumb" ] && [ -n "$GRC" ]; then
        alias colourify="$GRC"
        commands=(
            ant blkid configure df diff dig dnf docker-machinels dockerimages dockerinfo
            dockernetwork dockerps dockerpull dockersearch dockerversion du fdisk
            findmnt go-test ifconfig iostat_sar ip ipaddr ipneighbor iproute iptables
            irclog iwconfig kubectl last ldap lolcat lsattr lsblk lsmod lsof lspci
            lsusb mount mtr mvn netstat nmap ntpdate ping ping2 proftpd pv
            semanageboolean semanagefcontext semanageuser sensors showmount sockstat
            ss stat sysctl tcpdump traceroute tune2fs ulimit uptime vmstat wdiff yaml
        )
        for cmd in "${commands[@]}"; do
            if command -v "$cmd" >/dev/null; then
                alias "$cmd"="colourify $cmd"
            fi
        done
        unset commands cmd
    fi

    # Set GCC color settings for error and warning messages
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

    # Use 'bat' as a replacement for 'cat' with improved output formatting if available
    if command -v bat >/dev/null 2>&1; then
        cat() {
            local use_cat=false
            # Use regular cat if options -v, -e, or -t are present
            for arg in "$@"; do
                if [[ "$arg" =~ ^-[vet]+$ ]]; then
                    use_cat=true
                    break
                fi
            done
            if [ "$use_cat" == true ]; then
                command cat "$@"
            else
                bat --theme=Dracula --paging=never --style=plain "$@"
            fi
        }
        # Colorize help output
        h() {
            if [[ -z $1 ]] || [[ ${ type -t $1; } =~ (builtin|keyword) ]]; then
                help "$@" 2>&1 | bat --theme=Dracula --paging=never --style=plain --language=help
            else
                "$@" --help 2>&1 | bat --theme=Dracula --paging=never --style=plain --language=help
            fi
        }
        # Colorize man pages
        export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat --theme=Dracula -p -lman'"

        # Execute commands with syntax highlighting
        c() {
            local exit_code
            local has_output_option=false
            if [[ -t 1 && "$has_output_option" == "false" ]]; then
                if [[ -n $syntax ]]; then
                    bat_language="--language=$syntax"
                fi
                if [[ "$2" == "-h" || "$2" == "--help" ]]; then
                    bat_language="--language=help"
                fi
                set -o pipefail
                command "$@" | bat --theme=Dracula --paging=never --style=plain -f $bat_language
                exit_code=$?
                set +o pipefail
            else
                "$@"
                exit_code=$?
            fi
            return $exit_code
        }
        # Alias for running commands with specified bat language
        c_alias() {
            local exit_code
            local has_output_option=false
            if [[ -t 1 && "$has_output_option" == "false" ]]; then
                bat_language=$1
                shift
                set -o pipefail
                command "$@" | bat --theme=Dracula --paging=never --style=plain -f --language=$bat_language
                exit_code=$?
                set +o pipefail
            else
                command "$@"
                exit_code=$?
            fi
            return $exit_code
        }
        if command -v whois >/dev/null 2>&1; then
            alias "whois"="c_alias MemInfo whois"
        fi
        # Tab completion for 'h' command
        complete -A command -A builtin -A keyword h
    fi
fi

# ---------------- History Configuration ----------------
# Configure shell history settings for better usability
HISTCONTROL=ignoreboth      # Ignore duplicates and commands starting with a space
shopt -s histappend         # Append to the history file instead of overwriting it
HISTSIZE=2000               # Number of commands to remember in memory
HISTFILESIZE=2000           # Number of commands to store in the history file
shopt -s checkwinsize       # Adjust terminal window size after each command

# Enable case-insensitive tab completion
bind -s 'set completion-ignore-case on'

# Enable autocd and cdspell for easier directory navigation
shopt -s autocd
shopt -s cdspell

# Load additional aliases from ~/.bash_aliases if the file exists
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# ---------------- NVM Configuration ----------------
# Load Node Version Manager (NVM) if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ---------------- Auto-completion Configuration ----------------
# Enable programmable bash completion if available
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ---------------- FZF Configuration ----------------
# Load FZF key bindings and define custom search functions
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    eval "${ fzf --bash; }"
    # Define a 'find-in-file' (fif) function using FZF and ripgrep
    fif() {
        if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
        fzf --preview "highlight -O ansi -l {} 2> /dev/null | rga --ignore-case --pretty --context 10 '$1' {}" < <(rga --files-with-matches --no-messages "$1")
    }
fi
