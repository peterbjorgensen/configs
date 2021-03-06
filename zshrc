autoload -U promptinit
autoload -U compinit
compinit
promptinit

#Misc settings
bindkey -e #use emacs keybindings
prompt adam2

#### History options
HISTFILESIZE=1000000000
HISTSIZE=10000000
SAVEHIST=100000000
HISTFILE=~/.zsh_history
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

#Set terminal title to current working dir
#everytime prompt is shown
case $TERM in
	    xterm*|*rxvt*)
	precmd () {print -Pn "\e]0; %~\a"}
esac

#Environment variables
export OOO_FORCE_DESKTOP=gnome
export EDITOR='vim'
export WORDCHARS='' #Treat all special chars as word separators
export MATLABPATH='/home/peter/.matlab'

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
alias minicom="minicom -o"
alias quakelive="LD_PRELOAD='/usr/lib/libpng12.so' /usr/bin/firefox www.quakelive.com"
alias flub='woof'
alias ltcrop='~/.scripts/ltcrop.sh'
alias gta2='~/.scripts/gta2.sh'
alias aaussh='ssh pejor@skoda.es.aau.dk -X'
alias lundssh='ssh guest@lundgaard.dyndns.dk'
alias hdapsfixx='~/.scripts/hdaps.sh'
alias latexmkrapport="ls *.latexmain | xargs latexmk -pdf -pvc -silent"
alias ise='LD_PRELOAD=/home/peter/Desktop/usb-driver/libusb-driver.so /opt/xilinx/11.1/ISE/bin/lin/ise'
alias impact='LD_PRELOAD=/home/peter/Desktop/usb-driver/libusb-driver.so /opt/xilinx/11.1/ISE/bin/lin/impact'
alias skype64='ALSA_OSS_PCM_DEVICE="skype" aoss skype'
alias n='urxvt 2>/dev/null &!'
alias drp2='cvlc http://live-icy.gss.dr.dk:8000/A/A04H.mp3.m3u'
alias drp3='cvlc http://live-icy.gss.dr.dk:8000/A/A05H.mp3.m3u'
alias drp4nord='cvlc http://live-icy.gss.dr.dk:8000/A/A10H.mp3.m3u'
alias drp6='cvlc http://live-icy.gss.dr.dk:8000/A/A29H.mp3.m3u'
alias drp8='cvlc http://live-icy.gss.dr.dk:8000/A/A22H.mp3.m3u'
alias drjazz='drp8'
alias koqx='cvlc http://www.koqx.com/koqx.m3u'
alias dentungeradio='cvlc http://dentungeradio.dk/popup_player/dtr_stream.m3u'

###COLORS
export GREP_COLOR="1;33"
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
function svnci {
    svn up && svn ci -m "${*}"
    svn stat
}
function gca {
    git commit -a -m "${*}"
}

function mleps {
sed -i -e 's/\\303\\246/\\346/g' -e 's/\\303\\206/\\306/g' \
        -e 's/\\303\\270/\\370/g' -e 's/\\303\\230/\\330/g' \
        -e 's/\\303\\245/\\345/g' -e 's/\\303\\205/\\305/g' "$1" && \
    epstopdf "$1" && rm "$1"
}


function aauproxy {
export http_proxy=http://proxy.es.aau.dk:3128
}

function hpupdate {
	svn add --force ~/project/meetings || { echo "--- ERROR ---"; return }
	svn commit -m "hp update" ~/project/meetings || { echo "--- ERROR ---"; return }
	svn update /afs/ies.auc.dk/group/11gr651/public_html/svn/meetings
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

##############################


