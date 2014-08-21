# Options for Zsh
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

autoload -Uz compinit
setopt appendhistory autocd nomatch notify
unsetopt beep
bindkey -v #vim key

zstyle :compinstall filename '/home/marius/.zshrc'

compinit

# So that tramp doesent hang when connect through ssh...
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

# Aliases
alias ls='ls --color'
alias l='ls --color'
#alias eclipse='~/Programmering/program/eclipse/eclipse'
alias av='sudo shutdown -h now'
alias pacman32="pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /opt/arch32/pacman.conf"
#alias yi="~/.cabal/bin/yi -f pango --as=emacs"
alias yi="~/.cabal/bin/yi"
alias ec="emacsclient"

# Prompt
export PS1="$(print '%{\e[1;34m%}%n%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')$ "
export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Exports
#complete -cf sudo
#export GOROOT=$HOME/Programmering/program/go
#export GOOS=linux
#export GOARCH=amd64
#export GOBIN=$GOROOT/bin
#export PATH=$PATH:$GOBIN:/opt/andro
export PATH=$PATH:/home/marius/Programmering/Program/android-sdk-linux_x86/tools/:/home/marius/Programmering/Program/android-sdk-linux_x86/platform-tools/:/home/marius/.cabal/bin/:/home/marius/.gem/ruby/2.1.0/bin/
export GDK_NATIVE_WINDOWS=1
export EDITOR="vim"
export PATH=$PATH:~/.script/
export PACMAN=pacman
export TERM=rxvt-256color

# Auto extensions
alias -s html=$EDITOR
#alias -s org=$EDITOR
alias -s php=$EDITOR
#alias -s com=$EDITOR
#alias -s net=$EDITOR
alias -s png=feh
alias -s jpg=feh
alias -s gif=feg
alias -s avi=mplayer
alias -s sxw=soffice
alias -s doc=abiword
alias -s gz=tar -xzvf
alias -s bz2=tar -xjvf
alias -s java=$EDITOR
alias -s txt=$EDITOR
alias -s PKGBUILD=$EDITOR



###-begin-npm-completion-###
#
# npm command completion script
#
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###
