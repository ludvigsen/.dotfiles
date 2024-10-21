# Options for Zsh
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000

autoload -Uz compinit
setopt appendhistory autocd nomatch notify
unsetopt beep
bindkey -e #vim key
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

zstyle :compinstall filename '/home/marius/.zshrc'

compinit

# So that tramp doesent hang when connect through ssh...
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

# Aliases
alias k='kubectl'
#alias ls='ls -GF'
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias l='ls'
alias tls='tmux list-sessions'
alias t='tmux attach -t'
alias dup="docker images | awk 'BEGIN {OFS=\":\";}NR<2 {next}{print \$1, \$2}' | xargs -L1 docker pull"

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
export GOPATH=/Users/marius/go
export PATH=$PATH:/home/marius/Programmering/Program/android-sdk-linux_x86/tools/:/home/marius/Programmering/Program/android-sdk-linux_x86/platform-tools/:/home/marius/.cabal/bin/:/home/marius/.gem/ruby/2.1.0/bin/:/usr/lib/node_modules/karma/bin/:/home/marius/.gem/ruby/2.2.0/bin:/home/marius/Apps/Android/tools/
export PATH=$PATH:~/.local/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin
export JAVA_HOME=/Users/marius/Library/Java/JavaVirtualMachines/corretto-17.0.6/Contents/Home
export GDK_NATIVE_WINDOWS=1
export EDITOR="vim"
export PATH=$PATH:~/.scripts/
export DENO_INSTALL="/Users/marius/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
export PACMAN=pacman
export CHROME_BIN=google-chrome-stable

# Run projects
alias runSitemap='DB_PASSWORD=my-password;DB_URL=postgresql://localhost:5432/sitemap;DB_USERNAME=sitemap; /Users/marius/tv2/tv2play-api-sitemap/gradlew bootRun'

# Auto extensions
#alias -s html=$EDITOR
##alias -s org=$EDITOR
#alias -s php=$EDITOR
##alias -s com=$EDITOR
##alias -s net=$EDITOR
#alias -s png=feh
#alias -s jpg=feh
#alias -s gif=feg
#alias -s avi=mplayer
#alias -s sxw=soffice
#alias -s doc=abiword
#alias -s gz=tar -xzvf
#alias -s bz2=tar -xjvf
#alias -s java=$EDITOR
#alias -s txt=$EDITOR
#alias -s PKGBUILD=$EDITOR

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
[ -f ~/.bin/fubectl.source ] && source ~/.bin/fubectl.source

# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source ~/.dotfiles/fzf-git.sh/fzf-git.sh

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# ----- Bat (better cat) -----

export BAT_THEME=tokyonight_night

# the fuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"
alias cd="z"

# theme
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
