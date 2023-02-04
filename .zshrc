# Use powerline
USE_POWERLINE="true"

# Set default editor
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim

# GTK theme
export GTK_THEME=Adwaita-dark

## Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace                                          # Don't save commands that start with space

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word

## Alias section 

# General
alias shconf='vim ~/.zshrc && source ~/.zshrc'                  # shell configuration
alias xres='vim ~/.Xresources && xrdb -merge ~/.Xresources'
alias quit='shutdown now'
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias ll='ls -Aot --color'
alias free='free -m'                                            # Show sizes in MB
alias extract='tar -xvzf'
alias open='xdg-open'
alias c='clear'
alias todo='vim ~/todo.md && exit'
alias python3='/usr/bin/python'
alias pip='pip3'
# Restart f*cking wifi card driver
alias resath='sudo modprobe -r ath10k_pci && sudo modprobe ath10k_pci' 

# Vim
alias vim='nvim'
alias vimconf='vim ~/.config/nvim/init.vim'

# Git
alias gitu='git add . && git commit && git push'
# Dotfile repository configuration
alias config="/usr/bin/git --git-dir=$HOME/.cfg/.git --work-tree=$HOME"

# Pacman
alias update='sudo pacman -Syyu'
alias get='sudo pacman -S'

# Theming section  
autoload -U compinit colors zcalc
compinit -d
colors

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R


## Plugins section: Enable fish style features
# Use syntax highlighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# bind UP and DOWN arrow keys to history substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up			
bindkey '^[[B' history-substring-search-down

# Offer to install missing package if command is not found
if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
    source /usr/share/zsh/functions/command-not-found.zsh
    export PKGFILE_PROMPT_INSTALL_MISSING=1
fi

# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
function title {
  emulate -L zsh
  setopt prompt_subst

  [[ "$EMACS" == *term* ]] && return

  # if $2 is unset use $1 as default
  # if it is set and empty, leave it as is
  : ${2=$1}

  case "$TERM" in
    xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
      print -Pn "\e]2;${2:q}\a" # set window name
      print -Pn "\e]1;${1:q}\a" # set tab name
      ;;
    screen*|tmux*)
      print -Pn "\ek${1:q}\e\\" # set screen hardstatus
      ;;
    *)
    # Try to use terminfo to set the title
    # If the feature is available set title
    if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
      echoti tsl
      print -Pn "$1"
      echoti fsl
    fi
      ;;
  esac
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"

# Runs before showing the prompt
function mzc_termsupport_precmd {
  [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

# Runs before executing the command
function mzc_termsupport_preexec {
  [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return

  emulate -L zsh

  # split command into array of arguments
  local -a cmdargs
  cmdargs=("${(z)2}")
  # if running fg, extract the command from the job description
  if [[ "${cmdargs[1]}" = fg ]]; then
    # get the job id from the first argument passed to the fg command
    local job_id jobspec="${cmdargs[2]#%}"
    # logic based on jobs arguments:
    # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
    # https://www.zsh.org/mla/users/2007/msg00704.html
    case "$jobspec" in
      <->) # %number argument:
        # use the same <number> passed as an argument
        job_id=${jobspec} ;;
      ""|%|+) # empty, %% or %+ argument:
        # use the current job, which appears with a + in $jobstates:
        # suspended:+:5071=suspended (tty output)
        job_id=${(k)jobstates[(r)*:+:*]} ;;
      -) # %- argument:
        # use the previous job, which appears with a - in $jobstates:
        # suspended:-:6493=suspended (signal)
        job_id=${(k)jobstates[(r)*:-:*]} ;;
      [?]*) # %?string argument:
        # use $jobtexts to match for a job whose command *contains* <string>
        job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
      *) # %string argument:
        # use $jobtexts to match for a job whose command *starts with* <string>
        job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
    esac

    # override preexec function arguments with job command
    if [[ -n "${jobtexts[$job_id]}" ]]; then
      1="${jobtexts[$job_id]}"
      2="${jobtexts[$job_id]}"
    fi
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

autoload -U add-zsh-hook
add-zsh-hook precmd mzc_termsupport_precmd
add-zsh-hook preexec mzc_termsupport_preexec

# File and Dir colors for ls and other outputs
# export LS_OPTIONS='--color=auto'
eval "$(dircolors -b)"
# alias ls='ls $LS_OPTIONS'

# Prompt
autoload -Uz vcs_info
enable vcs_infoprecmd () { vcs_info }
zstyle ':vcs_info:*' formats ' (%F{81}%b%f)'
# 75, 69, 63 -- colors
# PROMPT='%B%F{75}%n%f%F{69}@%f%F{75}%m%f%k %B%F{69}%(4~|...|)%3~%f %F{75}$%f %b'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# () {
#   emulate -L zsh
# 
#   source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
#   source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# 
#   # Determine terminal capabilities.
#   {
#     if ! zmodload zsh/langinfo zsh/terminfo ||
#        [[ $langinfo[CODESET] != (utf|UTF)(-|)8 || $TERM == (dumb|linux) ]] ||
#        (( terminfo[colors] < 256 )); then
#       # Don't use the powerline config. It won't work on this terminal.
#       local USE_POWERLINE=false
#       # Define alias `x` if our parent process is `login`.
#       local parent
#       if { parent=$(</proc/$PPID/comm) } && [[ ${parent:t} == login ]]; then
#         alias x='startx ~/.xinitrc'
#       fi
#     fi
#   } 2>/dev/null
# 
#   if [[ $USE_POWERLINE == false ]]; then
#     # Use 8 colors and ASCII.
#     source /usr/share/zsh/p10k-portable.zsh
#     ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=black,bold'
#   else
#     # Use 256 colors and UNICODE.
#     source /usr/share/zsh/p10k.zsh
#     ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
#   fi
# }

## Paths
# Snap
PATH=$PATH:/snap/bin
# Local binaries
PATH=$PATH:~/.local/bin
# Tex
PATH=/usr/local/texlive/2022/bin/x86_64-linux:$PATH; export PATH 
MANPATH=/usr/local/texlive/2022/texmf-dist/doc/man:$MANPATH; export MANPATH 
INFOPATH=/usr/local/texlive/2022/texmf-dist/doc/info:$INFOPATH; export INFOPATH
TEXMFLOCAL=/usr/local/texlive/texmf-local; export TEXMFLOCAL
TEXMFHOME=$HOME/texmf; export TEXMFHOME
TEXMFVAR=$HOME/.texlive2020/texmf-var; export TEXMFVAR
# Python
PYTHONPATH=..:.:$PYTHONPATH; export PYTHONPATH
# Custom scripts
if [ -d $HOME/bin ]; then
    PATH=$HOME/bin:$PATH; export PATH
fi


# Git config
git config --global pager.branch 'false'

# CUDA TENSORFLOW
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/

# Starship prompt. THIS MUST BE THE LAST LINE
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/caio/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/caio/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/caio/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/caio/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
