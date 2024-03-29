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

if [[ -f /home/linuxbrew/.linuxbrew/bin/brew ]]
then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  export HOMEBREW_DEVELOPER=1
fi

[[ -d "/opt/texlive/2021/bin/x86_64-linux" ]] && appendpath "/opt/texlive/2021/bin/x86_64-linux"
[[ -d "$HOME"/.local/bin ]] && appendpath $HOME/.local/bin/
[[ -d "$HOME"/.cargo/ ]] && prependpath $HOME/.cargo/bin
[[ -d "$HOME/bin" ]] && prependpath $HOME/bin/

if command -v composer > /dev/null ; then
  appendpath "$(composer global config bin-dir --absolute --quiet)"
fi

if command -v ruby > /dev/null ; then
  GEMS_DIR="$(ruby -e 'puts Gem.user_dir')"
  appendpath $GEMS_DIR/bin
fi

if [[ -d "$HOME/Android/Sdk" ]]
then
  export ANDROID_HOME=$HOME/Android/Sdk
  appendpath $ANDROID_HOME/emulator
  appendpath $ANDROID_HOME/tools
  appendpath $ANDROID_HOME/tools/bin
  appendpath $ANDROID_HOME/platform-tools
fi


# original source:
#  http://sneakygcr.net/caged-python-how-to-set-up-a-scientific-python-stack-in-your-home-folder-without-going-insane.html
#
# Local Installs
# ==============
# This allows you to install programs into $HOME/local/someprogram
# for example, when I install node locally I install it like this:
#
#    ./configure --prefix=$HOME/local/node-v0.8.4
#    make
#    make install
#
# To uninstall a program, just rm -rf $HOME/local/someprogram
#============
# TODO: get rid of this, as guix/nix based package installations are much better!
if [ -d $HOME/local ]; then
  pattern="$(echo -n "${HOME}/local/" | sed -e 's/\//\\\//g')[^:]*"

  for i in PATH CPATH LD_RUN_PATH LD_LIBRARY_PATH PKG_CONFIG_PATH MANPATH
  do
    localess_v=$(echo -n "${!i}" \
      | sed -e 's/'"^${pattern}:"'/:/' -e 's/'":${pattern}$"'/:/' -e 's/'":${pattern}"'/:/g' \
      | sed -e 's/:::*/:/g' -e 's/^://' -e 's/:$//' \
      | sed -e 's/'"^${pattern}$"'//g')

    eval "${i}=\"${localess_v}\""
  done
  unset localess_v
  unset pattern

  for i in $HOME/local/* ; do
    [ -d $i/bin ] && prependpath "${i}/bin"
    [ -d $i/sbin ] && prependpath "${i}/sbin"
    [ -d $i/include ] && prepend_var "CPATH" "${i}/include"
    [ -d $i/lib ] && prepend_var "LD_LIBRARY_PATH" "${i}/lib"
    [ -d $i/lib ] && prepend_var "LD_RUN_PATH" "${i}/lib"
    [ -d $i/lib64 ] && prepend_var "LD_LIBRARY_PATH" "${i}/lib64"
    [ -d $i/lib64 ] && prepend_var "LD_RUN_PATH" "${i}/lib64"
    # uncomment the following if you use macintosh
    #  [ -d $i/lib ] && prependpath "DYLD_LIBRARY_PATH" "${i}/lib"
    [ -d $i/lib/pkgconfig ] && prepend_var "PKG_CONFIG_PATH" "${i}/lib/pkgconfig"
    [ -d $i/share/man ] && prepend_var "MANPATH" "${i}/share/man"
  done
  unset i

  MANPATH="${MANPATH}:" # : at end, preserves default manpaths
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH%:}
  LD_RUN_PATH=${LD_RUN_PATH%:}
  PKG_CONFIG_PATH=${PKG_CONFIG_PATH%:}
fi

if [[ -e "$HOME"/.asdf ]]
then
    ## modifies path!
    . "$HOME"/.asdf/asdf.sh
    . "$HOME"/.asdf/completions/asdf.bash
fi

if [[ -f ~/.fzf.bash ]]
then
    ## modifies path!
    source ~/.fzf.bash
    export FZF_CTRL_T_COMMAND='fd . -0'
    export FZF_CTRL_T_OPTS='--read0'
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

export PYTHONDONTWRITEBYTECODE=1
GPG_TTY=$(tty)
export GPG_TTY

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

if ! $OS_MAC && [[ -z "$SSH_TTY" ]] && [[ -z "$DISPLAY" ]] && [[ "$XDG_VTNR" -lt 3 ]]
then
    exec startx
fi
