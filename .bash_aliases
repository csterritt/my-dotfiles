# alias t=/usr/bin/less
alias ls='/opt/homebrew/bin/eza -F'
alias la='/opt/homebrew/bin/eza --all -F'
alias ll='/opt/homebrew/bin/eza -laF'
alias lt='/opt/homebrew/bin/eza -laF -sold'
alias lr='/opt/homebrew/bin/eza -laF --tree'
alias dust='/opt/homebrew/bin/dust -c'
alias yah='ping www.yahoo.com'
alias top='/usr/bin/top -s 4 -o cpu'
alias gtop='/opt/homebrew/bin/glances --theme-white'
alias purge='rm -f *~'
alias h='history | tail -30'
alias hh='history -f | tail -30'
alias hhl='history -f'
alias lowpri='/usr/bin/renice +20'
alias svnignore='svn propedit svn:ignore'
alias gsa='git status'
alias gs='git status -sb'
alias gdb='git diff -b'
alias gl='git l'
alias hn='/bin/hostname'
alias top10='/usr/bin/top -s 10 -o cpu'
# alias sd='search .'
alias h1='head -10'
alias h2='head -20'
alias h3='head -30'
alias h4='head -40'
alias t1='tail -10'
alias t2='tail -20'
alias t3='tail -30'
alias t4='tail -40'
alias ruserve='ruby -run -e httpd . -p 3000'
alias rss='rspec spec'
alias durn='du -k | sort -rn'
alias jpp='python3 -m json.tool'
alias j=jump
alias dk=docker
alias cbr='cargo build --release'
alias upup='brew update && brew upgrade && if [ -e /opt/homebrew/bin/node  ] ; then denode ; fi'
alias burd='brew upgrade --dry-run'
alias denode='brew uninstall --ignore-dependencies node'
alias si='./single_test_run'
alias gohere='export GOPATH=`pwd` ; export PATH=${PATH}:${GOPATH}/bin'
alias goi='go install'
alias gr='go run main.go'
alias rsd='tmux send-keys -t {down-of} C-c ./go C-m'
alias rsu='tmux send-keys -t {up-of} C-c ./go C-m'
alias rsu2='tmux send-keys -t {up-of} C-c \!\! C-m C-m'
alias renumber='tmux move-window -r'
alias serveo='ssh -R 80:localhost:3000 serveo.net'
alias trc="tr : '\012'"
# alias config='/opt/homebrew/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias ccat=/bin/cat
alias cat='/opt/homebrew/bin/bat --theme "Solarized (light)"'
alias t='/opt/homebrew/bin/bat --theme "Solarized (light)"'
alias nr="nim r '--hint[SuccessX]:off' '--hint[Conf]:off' '--hint[Link]:off' '--hint[Exec]:off'"

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
