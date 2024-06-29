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

# tmp is where I scratch my itch
alias tmp="pushd ${TMPDIR:-/tmp}"
