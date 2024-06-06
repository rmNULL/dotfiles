# -*- sh -*-
# enable color support of ls and other handy aliases

x_running() {
    # don't check for x in MAC
    $OS_MAC && return 0;
    if command -v xhost >/dev/null
    then
        xhost >/dev/null 2>&1
    else
        echo "xhost is not installed, can't detect whether x is running or not." >&2;
        return 0
    fi
}

if $OS_MAC
then
  alias ls="ls -G"
else
  alias ls='ls --color'
fi

alias ll='ls -hAlF'
alias la='ls -A'
alias l1='ls -1'
alias l='ls -CF'

if command -v exa >/dev/null 2>/dev/null
then
    alias l="exa --group-directories-first"
    alias ls="l"
    alias ll="ls -lh --no-permissions --octal-permissions"
    alias la="ls -a"
    alias l1="ls -1"
fi

alias grep='grep --color=auto'
alias egrep='grep -E'

if [[ -n $OS ]] && [[ $OS = *Linux* ]]
then
    ## package manager interface
    ## `++`  install a remote package
    ## `+-`  remove a remote package
    ## `+Q`  search for remote package
    ## `+q`  search for a local installed package
    ## `+u`  perform packages update, this may or not remove existing packages to satisfy dependency
    if command -v xbps-install >/dev/null 2>&1
    then
        alias ++='sudo xbps-install -y'
        alias +u='sudo xbps-install -Su'
        alias +-='sudo xbps-remove '
        +Q () {
            if [[ -n "$1" ]]
            then
                xbps-query -Rs "$1" --regex
            fi
        }
        +q () {
            if [[ "$#" -gt 0 ]]
            then
                xbps-query "$@"
            else
                xbps-query --help
            fi
        }
    fi

    if command -v dnf >/dev/null 2>&1
    then
        alias ++='sudo dnf install -y'
        alias +u='sudo dnf update'
        alias +-='sudo dnf remove -y'
        +Q () {
            dnf search "$@"
        }
        +q () {
            if [[ "$#" -gt 0 ]]
            then
                dnf list installed | grep "$1"
            fi
        }
    fi

    if command -v apt >/dev/null 2>&1
    then
        alias ++='sudo apt update && sudo apt install -y'
        alias +u='sudo apt update && sudo apt upgrade'
        alias +-='sudo apt remove'
        +Q () {
            if [[ -n "$1" ]]
            then
                apt-cache search "$1"
            fi
        }
        +q () {
            if [[ "$#" -gt 0 ]]
            then
                dpkg -l | grep "$1"
            fi
        }
    fi
fi
if $OS_MAC
then
  alias ++='brew install '
  alias +u='brew update '
  alias +-='brew uninstall '
  alias '+Q'='brew search '
  alias '+q'='brew search '
fi
## don't bother leaving behind shift
alias +_='+-'

if command -v guix >/dev/null
then
    alias gx='guix'
    alias gxh='guix help'
    alias gxi='guix install'
    alias gxp='guix package'
    alias gxq='guix search'
    alias gxs='guix shell'
    alias gxu='guix pull'
    alias gxdl='guix download'
    alias gxrm='guix remove'
fi

# if you need anything more than this better find an external tool(add a new line ;)
alias c.='cd ../'
alias c..='cd ../../'
alias c...='cd ../../../'
alias c3.="cd ../../../"
alias c4.="cd ../../../../"
alias c5.="cd ../../../../../"
alias c6.="cd ../../../../../../"
alias c7.="cd ../../../../../../../"
alias c8.="cd ../../../../../../../../"
alias c9.="cd ../../../../../../../../../"
# convenience
alias c1.="c."
alias c2.="c.."

alias +r='chmod +r'
alias +w='chmod +w'
alias +x='chmod +x'
alias r-='chmod -r'
alias w-='chmod -w'
alias x-='chmod -x'

alias mkdir='mkdir -p'
alias ping='ping -w 4 -c 3'
if command -v ruby >/dev/null
then
  alias ruby='ruby -w'
  alias   rb='ruby'

  command -v bundle >/dev/null && alias bexec='bundle exec'
fi

if command -v julia >/dev/null
then
    alias jl="julia --depwarn=error"
fi

if command -v npm >/dev/null
then
    alias Ν="npm run"
    alias ΝΝ="npm run start"
    alias ΝΒ="npm run build"
    alias ΝΜ="npm run dev"
fi

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

# tmp is where I scratch my itch
alias tmp="pushd ${TMPDIR:-/tmp}"
if command -v ffmpeg >/dev/null
then
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
fi

if command -v scrot >/dev/null
then
    scap() {
        local save_dir="/tmp/scaps/"
        mkdir -p "$save_dir"
        ## one of 'window' | 'select' | 'screen'
        local shot_mode="select" shot_mode_flag="-s"
        local delay=0
        local save_as="${save_dir}/#%s-${shot_mode}.png"

        scrot -d "$delay" "$shot_mode_flag" "$save_as"
    }
fi


if (command -v mupdf && command -v zenity) >/dev/null
then
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
alias mupdf-x11=mupdf
fi


if (command -v poly && command -v rlwrap) >/dev/null
then
  alias poly='rlwrap -pYellow poly'
fi


if (command -v nvim && ! command -v vim) >/dev/null 2>&1
then
  alias vim='nvim'
fi

for rc in "vimrc" "bashrc" "irbrc"
do
    alias $rc='$EDITOR '"$HOME/.${rc}"
done

command -v ipython 2>/dev/null >&2 && alias py=ipython
command -v     mpv 2>/dev/null >&2 && alias play='mpv --volume=100 --no-video'
if command -v tmux 2>/dev/null >&2
then
    tnew() {
        local session_name=""
        [[ -n "$1" ]] && session_name="-s$1"
        shift || :
        tmux new "$@" -n Music "${session_name}" ncmpcpp \; new-window "$SHELL"
    }

    tattach() {
        local sarg=""
        [[ -n "$1" ]] && sarg="-t${1}"
        tmux attach-session "${sarg[@]}" -d \; new-window "bash -c 'cd \"$PWD\"; ${SHELL:=bash}'" || tmux attach
    }

    tattachws() {
        local ws_name="" session_name=""

        ws_name=$(get-current-workspace-name | tr '[:upper:]' '[:lower:]')
        session_name="${ws_name:=${HOSTNAME}}"
        if [[ -z "$SSH_CONNECTION" ]]
        then
            if tmux has-session -t "$session_name" >/dev/null 2>&1
            then
                [[ -z $TMUX ]] && x_running && tattach "$session_name"
            else
                tnew "$session_name" -d
                x_running && {
                    tattach "$session_name"
                }
            fi
        fi
        true
    }
fi

if command -v gpg2 >/dev/null
then
  gpg() { gpg2 "$@"; }
fi

dice() {
    n="$1"
    echo "$(( RANDOM % n ))"
}

alias d2='dice 2'
alias d3='dice 3'
alias d4='dice 4'
alias d5='dice 5'
alias d6='dice 6'
alias d12='dice 12'
alias d20='dice 20'

if command -v bat >/dev/null 2>&1
then
    alias cat=bat
fi

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
