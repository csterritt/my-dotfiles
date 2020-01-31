source ~/.profile
source ~/.bash_aliases
source ~/.git-completion.bash
source ~/.colors
# export PS1="\! \[\033[1;36m\][\$(lastfew)]\[\033[0m\] \$ "
# export PS1="\! \[$UCyan\][\$(lastfew)]\[$Color_Off\] \$ "
export PS1="\! \[$BIWhite;$On_Cyan\][\$(lastfew)]\[$Color_Off\]\n\$ "
export EDITOR=/usr/bin/vi
export PATH=/usr/local/bin:/usr/local/sbin:$PATH
export HISTIGNORE='cd *:gs:gl:h'
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set up for ripgrep config
export RIPGREP_CONFIG_PATH=/Users/chris/.config/ripgrep/config.rc

# Add rust
export PATH=$PATH:/Users/chris/.cargo/bin
export RUST_SRC_PATH=/Volumes/Second/Chris/hacks/rust/rust/src
export CARGO_HOME=/Users/chris/.cargo

# Add go
# export GOPATH=/Users/chris/hacks/gofigure
export GOPATH=/Volumes/Second/Chris/hacks/gofigure
export PATH=${PATH}:${GOPATH}/bin

# rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# The next line updates PATH for the Google Cloud SDK.
# source '/Users/chris/google-cloud-sdk/path.bash.inc'

# The next line enables shell command completion for gcloud.
# source '/Users/chris/google-cloud-sdk/completion.bash.inc'

# Add NVM (installed via brew)
alias setup_nvm='
export NVM_DIR=~/.nvm
nvm_pth=$(brew --prefix nvm)/nvm.sh
. $nvm_pth
'
# nvm use v6.9.1

# Android sdk support
# export ANDROID_HOME=/usr/local/opt/android-sdk
# export JAVA_HOME=/Users/chris/Applications/RubyMine.app/Contents/jre/jdk/Contents/Home/jre

# Maven
# export PATH=${PATH}:/Volumes/Second/Chris/hacks/maven/apache-maven-3.3.9/bin

# Flutter
export JAVA_HOME=/Users/chris/hacks/flutter/jdk-10.0.1.jdk/Contents/Home
export PATH=/Users/chris/hacks/flutter/flutter/bin:${JAVA_HOME}/bin:${PATH}
