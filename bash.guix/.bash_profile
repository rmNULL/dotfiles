# -*- sh -*-
HOSTNAME=$(hostname)
HOSTNAME="${HOSTNAME:-eos}"
export HOSTNAME

OS=$(uname -s)
OS_MAC=$([[ $OS = *Darwin* ]] && echo "true" || echo "false")
export OS
export OS_MAC

append_var() {
  local var=$1
  shift

  eval "local V=\$$var"
  local ev=":$V:"

  case ":$V:" in
    *:"$1":*)
      # local pre=${path%%:"$1":*} post=${path#*:"$1":}
      # based on remove_path by `Soliton` from freenode#bash
      local pre=${ev%%:"$1":*}
      local post=${ev#*:"$1":}
      local V=${pre#:}:${post%:}

      ##
      eval "$var="\${$var:+$V:}$1""
      ;;
    *)
      # PATH="${PATH:+$PATH:}$1"
      eval "$var="\${$var:+$V:}$1""
  esac
}

prepend_var() {
  local var=$1
  shift
  eval "local V=\$$var"
  local ev=":$V:"

  case ":$V:" in
    *:"$1":*)
      # local pre=${path%%:"$1":*} post=${path#*:"$1":}
      # based on remove_path by `Soliton` from freenode#bash
      local pre=${ev%%:"$1":*}
      local post=${ev#*:"$1":}
      local V=${pre#:}:${post%:}

      ##
      eval "${var}="$1\${${var}:+:$V}""
      ;;
    *)
      # PATH="$1${PATH:+:$PATH}"
      eval "${var}="$1\${${var}:+:$V}""
  esac
}

# modified from /etc/profile
appendpath() {
  append_var "PATH" $1
}

prependpath() {
  prepend_var "PATH" $1
}

if ! [[ -d "$HOME"/bin ]]
then
  mkdir "$HOME"/bin
fi

[[ -d "/opt/texlive/2021/bin/x86_64-linux" ]] && appendpath "/opt/texlive/2021/bin/x86_64-linux"
[[ -d "$HOME"/.local/bin ]] && appendpath $HOME/.local/bin/
[[ -d "$HOME"/.cargo/ ]] && prependpath $HOME/.cargo/bin
[[ -d "$HOME/bin" ]] && prependpath $HOME/bin/

# if command -v ruby > /dev/null ; then
#   GEMS_DIR="$(ruby -e 'puts Gem.user_dir')"
#   appendpath $GEMS_DIR/bin
# fi

if [[ -d "$HOME/Android/Sdk" ]]
then
  export ANDROID_HOME=$HOME/Android/Sdk
  appendpath $ANDROID_HOME/emulator
  appendpath $ANDROID_HOME/tools
  appendpath $ANDROID_HOME/tools/bin
  appendpath $ANDROID_HOME/platform-tools
fi

if [[ -e "$HOME"/.asdf ]]
then
    ## modifies path!
    . "$HOME"/.asdf/asdf.sh
    . "$HOME"/.asdf/completions/asdf.bash
else
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.2
    ~/.asdf/bin/asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    ~/.asdf/bin/asdf install nodejs lts-gallium
    ~/.asdf/bin/asdf install nodejs lts-hydrogen
    ~/.asdf/bin/asdf install nodejs latest
fi

if [[ -f ~/.fzf.bash ]]
then
    ## modifies path!
    source ~/.fzf.bash
fi

## modifies path!
GUIX_PROFILE="${HOME}/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
export GUIX_LOCPATH="$HOME"/.guix-profile/lib/locale
# . "${HOME}/.config/guix/current/etc/profile"

export PATH
export MANPATH
export LD_LIBRARY_PATH
export LD_RUN_PATH
export PKG_CONFIG_PATH
unset prependpath
unset appendpath
unset append_var
unset prepend_var

# GPG_TTY=$(tty)
# export GPG_TTY

if [[ -r "${HOME}/.ripgreprc" ]]
then
    export RIPGREP_CONFIG_PATH="${HOME}/.ripgreprc"
fi

export GPODDER_HOME="${HOME}/Music/Pods/gPodder"

# JAVA_HOME="/usr/lib/jvm/openjdk11/"
# if [[ -d "${JAVA_HOME}" ]]
# then
#     export JAVA_HOME
# else
#     unset JAVA_HOME
# fi

[[ -d "${HOME}/.local/share/tessdata_best" ]] && export TESSDATA_PREFIX="${HOME}/.local/share/tessdata_best"


[[ -f ~/.bashrc ]] && source ~/.bashrc

#if ! $OS_MAC && [[ -z "$SSH_TTY" ]] && [[ -z "$DISPLAY" ]] && [[ "$XDG_VTNR" -lt 3 ]]
#then
#    exec startx
#fi


# if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
#   MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
# fi
