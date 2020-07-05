#!/usr/bin/env bash
set -e

plain_patchelf=""
print_before_and_after=""

while :
do
  if [[ "$1" = "-p" ]]
  then
    plain_patchelf="1"
  elif [[ "$1" = "-d" ]]
  then
    print_before_and_after="1"
  else
    break
  fi
  shift
done


elf="$1"
[[ -z "$1" ]] && exit 21
prefix=$(brew --prefix)

chmod +w "$elf"
if patchelf --print-interpreter "$elf" >/dev/null 2>&1
then
  interp=$(patchelf --print-interpreter "$elf")

  [[ -n "$print_before_and_after" ]] && echo -e "========\ninterp: $interp"

  if [[ $interp =~ ^@@HOMEBREW_PREFIX@@.*$ ]]
  then
    interp=${interp/@@HOMEBREW_PREFIX@@/"$prefix"}

    if [[ -n $plain_patchelf ]]
    then patchelf="patchelf"
    else patchelf="patchelf.rb"
    fi

    if ! "$patchelf" --set-interpreter "$interp" "$elf"
    then
      echo "$elf" >> /tmp/fails
      exit 1
    fi

  fi
fi


if patchelf --force-rpath --print-rpath "$elf" >/dev/null 2>&1
then
  esc_prefix=$(echo "$prefix" | sed -e 's/\//\\\//g')
  rpath=$( patchelf --force-rpath --print-rpath "$elf" | sed -e "s/@@HOMEBREW_PREFIX@@/${esc_prefix}/g" )

  [[ -n "$print_before_and_after" ]] && echo " rpath: $rpath"

  if [[ -n $plain_patchelf ]]
  then patchelf="patchelf"; rp_flag="--force-rpath --set-rpath"
  else patchelf="patchelf.rb"; rp_flag="--force-rpath --set-runpath"
  fi

  if ! $patchelf $rp_flag  "${rpath%:}" "$elf"
  then
    echo "$elf" >> /tmp/fails
    exit 2
  fi
fi

if [[ -n $print_before_and_after ]]
then
  echo -en "========\ninterp: "
  patchelf --print-interpreter "$elf"
  echo -en " rpath: "
  patchelf --force-rpath --print-rpath "$elf"
fi
