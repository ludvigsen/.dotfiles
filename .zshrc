# Options for Zsh
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

autoload -Uz compinit
setopt appendhistory autocd nomatch notify
unsetopt beep
bindkey -e #vim key

zstyle :compinstall filename '/home/marius/.zshrc'

compinit

# So that tramp doesent hang when connect through ssh...
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

# Aliases
alias ls='ls -GF'
alias l='ls -GF'
#alias eclipse='~/Programmering/program/eclipse/eclipse'
alias av='sudo shutdown -h now'
alias tls='tmux list-sessions'
alias t='tmux attach -t'
alias dup="docker images | awk 'BEGIN {OFS=\":\";}NR<2 {next}{print \$1, \$2}' | xargs -L1 docker pull"
#alias pacman32="pacman --root /opt/arch32 --cachedir /opt/arch32/var/cache/pacman/pkg --config /opt/arch32/pacman.conf"
#alias yi="~/.cabal/bin/yi -f pango --as=emacs"
#alias yi="~/.cabal/bin/yi"
#alias ec="emacsclient"

# Prompt
export PS1="$(print '%{\e[1;34m%}%n%{\e[0m%}'):$(print '%{\e[0;34m%}%~%{\e[0m%}')$ "
#export PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"

# Exports
#complete -cf sudo
#export GOROOT=$HOME/Programmering/program/go
#export GOOS=linux
#export GOARCH=amd64
#export GOBIN=$GOROOT/bin
#export PATH=$PATH:$GOBIN:/opt/andro
export PATH=$PATH:/home/marius/Programmering/Program/android-sdk-linux_x86/tools/:/home/marius/Programmering/Program/android-sdk-linux_x86/platform-tools/:/home/marius/.cabal/bin/:/home/marius/.gem/ruby/2.1.0/bin/:/usr/lib/node_modules/karma/bin/:/home/marius/.gem/ruby/2.2.0/bin:/home/marius/Apps/Android/tools/
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk/
export GDK_NATIVE_WINDOWS=1
export EDITOR="vim"
export PATH=$PATH:~/.scripts/
export PACMAN=pacman
export CHROME_BIN=google-chrome-stable

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

#export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
#export GEM_HOME=$(ruby -e 'print Gem.user_dir')
export PATH="$PATH:$HOME/.gem/ruby/2.0.0/bin"

# KAFKA
export KAFKA_HOME=/usr/local/kafka
export KAFKA=/usr/local/kafka/bin
export KAFKA_CONFIG=/usr/local/kafka/config

export ANDROID_HOME=/home/marius/Apps/Android
export ANDROID_SDK=/home/marius/Apps/Android


#eval "$(docker-machine env default)"

# Convinient functions
runApi(){
  java -Dapi.local.properties=/Users/marius/api-configuration.properties -Dsolr.home.properties=/Users/marius/vimond/VimondRestAPI/docker/docker-solr.properties -jar core-api-web-standalone/build/libs/`ls -t core-api-web-standalone/build/libs | head -1` server --settings core-api-web-standalone/vimond_api_settings_local_vagrant.properties
}

compileAndRun(){
  ./gradlew build -x test && runApi
}

migrateApi(){
  java -jar core-api-web-standalone/build/libs/`ls -t core-api-web-standalone/build/libs | head -1` db migrate --non-interactive --settings core-api-web-standalone/vimond_api_settings_local_vagrant.properties
}


# Tmux sessions
tinycast(){
if tmux info &> /dev/null; then 
  echo tmux running
else
  tmux start-server
fi

tmux has-session -t tinycast 2> /dev/null

# Check the return value of previous command:
if [[ $? -eq 0 ]]; then
  echo "Session exists"
else
  tmux new-session -d -s tinycast -n Editor
  tmux new-window -t tinycast:2 -n Server
  tmux new-window -t tinycast:3 -n Terminal
  tmux send-keys -t tinycast:1 "cd ~/tinycast/" C-m
  tmux send-keys -t tinycast:2 "cd ~/tinycast/" C-m
  tmux send-keys -t tinycast:3 "cd ~/tinycast/" C-m
  tmux send-keys -t tinycast:1 "nvim" C-m
  tmux send-keys -t tinycast:2 "npm start" C-m
fi
tmux select-window -t tinycast:1
tmux attach-session -t tinycast
}

vcc-curation(){
if tmux info &> /dev/null; then 
  echo tmux running
else
  tmux start-server
fi

tmux has-session -t vcc-curation 2> /dev/null

# Check the return value of previous command:
if [[ $? -eq 0 ]]; then
  echo "Session exists"
else
  tmux new-session -d -s vcc-curation -n Editor
  tmux new-window -t vcc-curation:2 -n Test
  tmux new-window -t vcc-curation:3 -n Server
  tmux new-window -t vcc-curation:4 -n Terminal
  tmux send-keys -t vcc-curation:1 "cd ~/vimond/vcc-curation/" C-m
  tmux send-keys -t vcc-curation:2 "cd ~/vimond/vcc-curation/" C-m
  tmux send-keys -t vcc-curation:3 "cd ~/vimond/vcc-curation/" C-m
  tmux send-keys -t vcc-curation:4 "cd ~/vimond/vcc-curation/" C-m
  tmux send-keys -t vcc-curation:1 "nvim" C-m
  tmux send-keys -t vcc-curation:2 "npm run test-watch" C-m
  tmux send-keys -t vcc-curation:3 "export CMS_TENANTS=\"[{'value': 'vimond', 'label': 'Vimond' },{ 'value': 'acme', 'label': 'Acme' }]\"; export CMS_API_SECRET=\"{SSHA}7cFtZruWJq7itGdtgI28K7/wRm07qybrm/T28w==\"; export CMS_API_URL=http://localhost:8080/api/; export CMS_PGSQL_USER='vimond'; export CMS_PGSQL_DB='tv2stage';export CMS_PGSQL_HOST='localhost'; export CMS_PGSQL_PASSWORD='peltonasje';export CMS_JWT_SECRET=d7a1ecf19a080d66a5e31dee61c65f2cad8ac56cdc28bfdda1a644e5e3849aa5fa272dea5c3603b7be68f73e3bf5de22ebf8c603fe35305b2c339998f5478103; npm run start-notest" C-m
fi
tmux select-window -t vcc-curation:1
tmux attach-session -t vcc-curation
}

vimond-cms(){

cd ~/vimond/vimond-cms

if tmux info &> /dev/null; then 
  echo tmux running
else
  tmux start-server
fi

tmux has-session -t vimond-cms 2> /dev/null
# Check the return value of previous command:
if [[ $? -eq 0 ]]; then
  echo "Session exists"
else
  tmux new-session -d -s vimond-cms -n Editor
  tmux new-window -t vimond-cms -n Test
  tmux new-window -t vimond-cms -n "Server Backend"
  tmux new-window -t vimond-cms -n "Server Frontend"
  tmux new-window -t vimond-cms -n Terminal

  tmux send-keys -t vimond-cms:1 "cd ~/vimond/vimond-cms/" C-m
  tmux send-keys -t vimond-cms:2 "cd ~/vimond/vimond-cms/" C-m
  tmux send-keys -t vimond-cms:3 "cd ~/vimond/vimond-cms/" C-m
  tmux send-keys -t vimond-cms:4 "cd ~/vimond/vimond-cms/" C-m
  tmux send-keys -t vimond-cms:5 "cd ~/vimond/vimond-cms/" C-m
  tmux send-keys -t vimond-cms:1 "nvim" C-m
  tmux send-keys -t vimond-cms:2 "npm run test-watch" C-m
  tmux send-keys -t vimond-cms:3 "CMS_VIAM_CREDENTIALS='{\"domain\": \"vimond-dev.eu.auth0.com\", \"clientId\": \"wZXLUB3WbwogW7pn9SE1gYl4gELgymkz\", \"clientSecret\": \"HqWmShcNKdNecsblwYS4dGfFBczAN-pzH0JEhMFxDdDIc0a0dQovJUNs5h6lL2dK\"}' CMS_AUTH0_DOMAIN=vimond-dev.eu.auth0.com CMS_AUTH0_CLIENT_ID=wZXLUB3WbwogW7pn9SE1gYl4gELgymkz CMS_AUTH0_CLIENT_SECRET=HqWmShcNKdNecsblwYS4dGfFBczAN-pzH0JEhMFxDdDIc0a0dQovJUNs5h6lL2dK ./start-backend.sh dev d7a1ecf19a080d66a5e31dee61c65f2cad8ac56cdc28bfdda1a644e5e3849aa5fa272dea5c3603b7be68f73e3bf5de22ebf8c603fe35305b2c339998f5478103 asdf cur" C-m
  tmux send-keys -t vimond-cms:4 "CMS_CURATION_SERVICE_URL_EXTERNAL=http://localhost:10016/ PORT=9090 ./start-frontend.sh dev cms cur" C-m
fi
tmux select-window -t vimond-cms:1
tmux attach-session -t vimond-cms
}
