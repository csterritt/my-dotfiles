alias t=/usr/bin/less
alias ls='/bin/ls -F'
alias la='/bin/ls -asF'
alias ll='/bin/ls -lasF'
alias yah='ping www.yahoo.com'
alias top='/usr/bin/top -s 4 -o cpu'
alias purge='rm -f *~'
alias h=history
alias lowpri='/usr/bin/renice +20'
alias svnignore='svn propedit svn:ignore'
alias gsa='git status'
alias gs='git status -sb'
alias gdb='git diff -b'
alias gl='git l'
# alias cfp='cucumber --format progress'
# alias sc='/usr/bin/screen -e^_-'
alias hn='/bin/hostname'
alias top10='/usr/bin/top -s 10 -o cpu'
alias sd='search .'
alias h1='head -10'
alias h2='head -20'
alias h3='head -30'
alias h4='head -40'
alias t1='tail -10'
alias t2='tail -20'
alias t3='tail -30'
alias t4='tail -40'
#alias pyserve='python -m SimpleHTTPServer 3000'
alias ruserve='ruby -run -e httpd . -p 3000'
#alias v=/usr/local/bin/vagrant
#alias ijulia='ipython notebook --profile julia'
#alias jl=julia
alias rss='rspec spec'
#alias z='zeus'
#alias im='iex -S mix'
#alias myredis='/usr/local/bin/redis-server /usr/local/etc/redis.conf'
#alias rag='ag --ruby'
alias durn='du -k | sort -rn'
#alias hp='$(history | cut -c8- | sort -u | pick)'
alias jpp='python -m json.tool'
alias j=jump
alias dk=docker
#alias weatherck='curl http://192.168.88.237:4000/api/time_and_weather?format=json ; echo'
alias cbr='cargo build --release'
alias upup='brew update && brew upgrade'
alias si='./single_test_run'
alias gohere='export GOPATH=`pwd` ; export PATH=${PATH}:${GOPATH}/bin'
alias goi='go install'
alias gr='go run main.go'
alias rsd='tmux send-keys -t {down-of} C-c Up C-m'
alias rsu='tmux send-keys -t {up-of} C-c Up C-m'
alias serveo='ssh -R 80:localhost:3000 serveo.net'
alias trc="tr : '\012'"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export LESS='-RMIX'

export MARKPATH=$HOME/.marks
function jump {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    \ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}

qq() {
    clear

    logpath="$TMPDIR/q"
    if [[ -z "$TMPDIR" ]]; then
        logpath="/tmp/q"
    fi

    if [[ ! -f "$logpath" ]]; then
        echo 'Q LOG' > "$logpath"
    fi

    tail -100f -- "$logpath"
}

rmqq() {
    if [[ -f "$TMPDIR/q" ]]; then
        rm "$TMPDIR/q"
    fi
    qq
}
