# -*- sh -*-
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !

# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]
then
    # Shell is non-interactive.  Be done now!
    return
fi

### HISTSIZE: quoting the source, since i keep forgetting what this means
###  > The  number  of  commands  to remember in the command history.
###  > If the value is 0, commands are not saved in the history list.
###  > Numeric values less than zero result in every command being saved on the history list (there is no limit)
###  > The shell sets the default value to 500 after reading any startup files.
export HISTSIZE=-1
export HISTFILESIZE=1000000
# Don't execute commands when match fails
shopt -s failglob
shopt -s histappend
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

JAVA_HOME="/usr/lib/jvm/java-1.17.0-openjdk-amd64/"
if [[ -d "${JAVA_HOME}" ]]
then
    export JAVA_HOME
else
    unset JAVA_HOME
fi

[[ -d "${HOME}/.local/share/tessdata_best" ]] && export TESSDATA_PREFIX="${HOME}/.local/share/tessdata_best"



# if [[ -z $DISPLAY && $(tty) == /dev/tty1 && $XDG_SESSION_TYPE == tty ]]; then
#   MOZ_ENABLE_WAYLAND=1 QT_QPA_PLATFORM=wayland XDG_SESSION_TYPE=wayland exec dbus-run-session gnome-session
# fi


## inject to shell
. "$HOME/.cargo/env"
eval "$(zoxide init bash)"
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
eval "$(fzf --bash)"

if ! command -v get-current-workspace-name >/dev/null
then
    get-current-workspace-name() { :; }
fi

PREV_ORG_PROMPT=""

gen_prompt() {
    local ec="$?"
    local branch="" user_prefix="" hints="" ORG_PROMPT=""
    history -a
    history -n

    # kludge !!, as long as it works
    PS1=$(echo -n "$PS1" | sed 's/^\\e\[41;37;1m [0-9][0-9]* \\e\[0m\s*//')

    if command -v git >/dev/null 2>/dev/null
    then
        branch="$(git branch --show-current 2>/dev/null)"
        [[ -n "$branch" ]] &&
            branch="\e[47m\e[30m${branch:+ }${branch}${branch:+ }\e[0m"
    fi

    if [[ "$USER" != "rmnull" ]] || [[ -n "$SSH_CONNECTION" ]]
    then
        user_prefix="\e[31;1m\u\e[0m @ \e[33;1m\h\e[0m"
    else
        user_prefix=""
    fi

    if [[ -n $HOMEBREW_DEVELOPER ]]
    then
        hints+="\e[1;33m🍺\e[;0m"
    fi

    if [[ -n "$GUIX_ENVIRONMENT" ]]
    then
        local color="\e[38;5;166m" end_color="\e[0m"
        local guix_hint="${color}guix${end_color}"
        hints="[${guix_hint}]${hints:+ ${hints}}"
    fi

    ORG_PROMPT="${user_prefix}${user_prefix:+: }${branch:+${branch}}${branch:+ }${hints}\e[38;5;227m \w\e[0m\n∫ "

    if [[ -z $PREV_ORG_PROMPT ]]
    then
        PREV_ORG_PROMPT=$ORG_PROMPT
    fi

    # of course, this assumes other scripts don't make modifications to the
    # in the middle of PS1
    # dont overwrite prompt generated by other scripts
    # other scripts may have added additional info the prompt
    local pre_diff="" PREFIX=""
    pre_diff="$(( ${#PS1} - ${#PREV_ORG_PROMPT} ))"
    if [[ $pre_diff -gt 0 ]]
    then
        PREFIX="${PS1:0:${pre_diff}}"
    else
        PREFIX=""
    fi
    local SUFFIX="${PS1:$(( ${#PREFIX} + ${#PREV_ORG_PROMPT} ))}"

    PS1="${PREFIX}${ORG_PROMPT}${SUFFIX}"
    PREV_ORG_PROMPT=${ORG_PROMPT}

    if [[ $ec != "0" ]] ; then
        PS1="\e[41;37;1m $ec \e[0m ${PS1}"
    fi
}


__eos_venv_activate() {
    local venv_dir=".venv"
    local desired_venv
    local current_venv

    [[ -d $venv_dir ]] || return

    desired_venv=$(realpath "$venv_dir") || return
    current_venv=$(realpath "${VIRTUAL_ENV:-}" 2>/dev/null || true)

    if [[ "$current_venv" != "$desired_venv" ]]; then
        type deactivate &>/dev/null && deactivate
        source "$desired_venv/bin/activate"
    fi
}


if [[ -z "$PROMPT_COMMAND" ]]
then
    PROMPT_COMMAND="gen_prompt;__eos_venv_activate"
else
    PROMPT_COMMAND="gen_prompt;${PROMPT_COMMAND};__eos_venv_activate;"
fi

if [[ -f ~/.bash_aliases ]]
then
    . ~/.bash_aliases
fi

srec() {
    if [[ $# -gt 0 ]]
    then
        echo -e "WARN: doesn't accept any args. Ignoring all the arguments\n\n"
    fi

    local date_format=$(date --iso-8601=minutes)
    local save_dir="${HOME}/Videos/screenrecords"
    local out="${save_dir}/srec_${date_format}"
    local out_ll="${out}.mkv"
    local out_lo="${out}.webm"
    local display=${DISPLAY:-0.0}
    mkdir -p "$save_dir"
    ffmpeg -video_size 1920x1080 -framerate 30 -f x11grab -i "$display" -c:v libx264rgb -crf 0 -preset ultrafast "${out_ll}" \
        && ffmpeg -i "$out_ll" "$out_lo" && echo "saved to $out_lo"
}
rand_sym() {
    if [[ -z "$1" ]]
    then
        return;
    fi
    local symbols=$1;
    ## restrict to 7 bytes(2 ^ 56), as bash overflows at 2 ^ 63
    local randint=$(od --output-duplicates --address-radix=n --read-bytes=7 -t u8 </dev/urandom);
    local symbol_idx=$(( randint % ${#symbols} ))
    echo "${symbols:$symbol_idx:1}"
}

genpwd() {
    local dict_file="${HOME}/af/words-nouns.txt"
    [[ -e "$dict_file" ]] || return;
    local n_words=6;
    local min_word_len=3;
    local max_word_len=10;
    local separator=$(rand_sym '+-*/=_,.~><;:| ');
    local padding_symbol=$(rand_sym '~!@#$%^&*([{+=/|');
    local padding_start_symbol=$padding_symbol;
    local padding_end_symbol=$padding_symbol;
    [[ $padding_symbol = "(" ]] && padding_end_symbol=")";
    [[ $padding_symbol = "[" ]] && padding_end_symbol="]";
    [[ $padding_symbol = "{" ]] && padding_end_symbol="}";

    awk '/^[a-zA-Z0-9]+$/ && length($0) >= '"$min_word_len"' && length($0) <= '"$max_word_len" "$dict_file" \
        | shuf --repeat --random-source=/dev/urandom -n $n_words \
        | tr '\n' "$separator" \
        | tr '[:upper:]' '[:lower:]' \
        | sed -e 's/^\(.*\).$/\1/' \
        | xargs -I _ echo "$padding_start_symbol"_"$padding_end_symbol"
}

mupdf() {
    elog=$(command mupdf "$@" 2>&1)
    local mupdf_ec=$?

    if [[ "$mupdf_ec" != "0" ]] && grep -i '^error: needs a password' <<<"$elog"
    then
        local pass=$(zenity --title="PDF Password" --password)
        command mupdf -p "$pass" "$@"
        mupdf_ec=$?
    else
        echo -e "$elog" >&2
    fi

    ## honor MuPDF exit status
    return $mupdf_ec
}

scap() {
    local save_dir="${HOME}/Pictures/scaps/"
    mkdir -p "$save_dir"
    ## one of 'window' | 'select' | 'screen'
    local shot_mode="select" shot_mode_flag="-s"
    local delay=0
    local save_as="${save_dir}/#%s-${shot_mode}.png"

    scrot -d "$delay" "$shot_mode_flag" "$save_as"
}

if command -v git >/dev/null
then
  alias gi='git init'
  alias g='git'

  ## auto completion for aliases
  if [[ -n $OS ]] && [[ $OS = *Linux* ]]
  then
    git_completion_file="/usr/share/bash-completion/completions/git"
  else
    git_completion_file="/tmp/hopefully-non/existing-fil/e--and-directory/placeholder"
  fi

  if [[ -f "$git_completion_file" ]]
  then
    ## pollute the environment!!
    source "$git_completion_file"
    __git_complete g __git_main
  fi

  unset git_completion_file
fi

## this var is the reason behind gnome icons missing 
unset GDK_PIXBUF_MODULE_FILE
.vv() {
  source "$PWD/.venv/bin/activate"
}

if [[ "$TERM" = "alacritty" ]]
then
    tattachws 2>/dev/null
fi

export DATASET_ROOT_FACE=/mnt/dump/datasets/sanitized/face
export DATASET_ROOT_IRIS=/mnt/dump/datasets/sanitized/iris
export DATASET_ROOT_FINGER=/mnt/dump/datasets/sanitized/finger

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/sham/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/sham/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/sham/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/sham/Downloads/google-cloud-sdk/completion.bash.inc'; fi
