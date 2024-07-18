### If not running interactively, don't do anything
[[ $- != *i* ]] && return

### Auto cd
shopt -s autocd

### disable Ctrl-S, Ctrl-Q
stty -ixon

### History
unset HISTFILESIZE
HISTSIZE=100000
export HISTCONTROL=ignoredups                # ignore duplicates
shopt -s histappend                          # enable history appending instead of overwriting when exiting
PROMPT_COMMAND="history -a;$PROMPT_COMMAND"  # write command to history immediately

### Use bash-completion if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion

# Use bash-completion for git if available
[[ $PS1 && -f /usr/share/bash-completion/completions/git ]] && . /usr/share/bash-completion/completions/git

### Setting PS1
export PS1="\[\e]0;\u: \w\a\]\[\033[01;31m\][\[\033[01;32m\]\u \[\033[01;34m\]\w\[\033[01;31m\]]\[\033[00m\]\$ "

### Aliases
alias c="clear"
alias ls="ls -hN --color=auto --group-directories-first"
alias la="ls -A"
alias lA="ls -lA"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias g="git"
alias ga="git add"
alias gc="git checkout"
alias gd="git diff"
alias gl="git log --graph --all"
alias gs="git status"
alias gf="git fetch"
alias gp="git pull"
alias v="nvim"
alias sv="sudo -E nvim"
alias act="source venv/bin/activate"
alias y="yay"
alias ya="yay -Syua"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -vI"
alias rsync="rsync -Prv"
alias i="ip -br -c a"

### fzf
# Source auto-completion and key bindings
[[ $- == *i* ]] && source "/usr/share/fzf/completion.bash" 2> /dev/null; source "/usr/share/fzf/key-bindings.bash"

### Autojump
[[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/oz/projects/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/oz/projects/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/oz/projects/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/oz/projects/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

