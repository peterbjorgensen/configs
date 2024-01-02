# Add user generated completion (for example for poetry)
fpath+=~/.zfunc

autoload -U promptinit
autoload -U compinit
compinit
promptinit

#Misc settings
bindkey -e #use emacs keybindings
#prompt adam2
plugins=(
	git
	virtualenv
)
#ZSH_THEME="candy"
ZSH_THEME="amuse_custom"
#ZSH_THEME="robbyrussell"
source /usr/share/oh-my-zsh/oh-my-zsh.sh
#VIRTUAL_ENV_DISABLE_PROMPT=0
#unset VIRTUAL_ENV_DISABLE_PROMPT

#### History options
HISTFILESIZE=1000000000
HISTSIZE=10000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history
#PATH=$PATH:~/.local/bin
setopt inc_append_history
setopt hist_find_no_dups
setopt hist_no_functions
setopt hist_save_no_dups
setopt share_history

#### Completion
zstyle ':completion:*' rehash yes #always rehash external commands
zstyle ':completion:*' menu select #arrow key-driven completion
zstyle ':completion:*' special-dirs true	# allow cd ..
# allow approximate completion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
#case-insensitive
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
#complete killall command
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:processes-names' command 'ps -aeo comm='
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu select
zstyle ':completion:*:*:killall:*:processes-names' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:killall:*' menu select
# Just complete local files in git completion, otherwise it is too slow
__git_files () { 
    _wanted files expl 'local files' _files  }

#Set terminal title to current working dir
#everytime prompt is shown
case $TERM in
	    alacritty|xterm*|*rxvt*|st*)
	precmd () {print -Pn "\e]0; %~\a"}
esac

#Environment variables
export OOO_FORCE_DESKTOP=gnome
export EDITOR='nvim'
export WORDCHARS='' #Treat all special chars as word separators

#suffix-alias
alias -s tex=$EDITOR
alias -s c=$EDITOR
alias -s h=$EDITOR
alias -s asm=$EDITOR
alias -s txt=$EDITOR

#aliases
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias lc="cl"
alias flub='woof'
alias latexmkrapport="ls *.latexmain | xargs latexmk -pdf -pvc -silent"
alias n='alacritty 2>/dev/null &!'
alias nvimdiff='nvim -d'
alias vim='nvim'
alias conda-init="[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh"

###COLORS
export GREP_COLORS="1;33"
eval `dircolors -b`
# Colored manpage
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

#helperfunctions
###################################
function cl () {
   if [ $# = 0 ]; then
      cd && ll
   else
      cd "$*" && ll
   fi
}

function history-search-end {
    integer ocursor=$CURSOR

    if [[ $LASTWIDGET = history-beginning-search-*-end ]]; then
      # Last widget called set $hbs_pos.
      CURSOR=$hbs_pos
    else
      hbs_pos=$CURSOR
    fi

    if zle .${WIDGET%-end}; then
      # success, go to end of line
      zle .end-of-line
    else
      # failure, restore position
      CURSOR=$ocursor
      return 1
    fi
}
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

########################

#key bindings for compatibility with terminal emus
# arrow up
bindkey "\e[A" history-beginning-search-backward-end
bindkey "\e[B" history-beginning-search-forward-end
####################### key bindings from archwiki
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# For termite (VTE based)
bindkey "\e[1;3D" backward-word # alt-right
bindkey "\e[1;3C" forward-word # alt-left
bindkey "\e[1;5D" emacs-backward-word # ctrl-left
bindkey "\e[1;5C" emacs-forward-word # ctrl-right

##############################

# High dpi settings
# QT
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
