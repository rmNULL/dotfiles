#!/usr/bin/env bash
set -e

plain_patchelf=""
if [[ "$1" = "-p" ]]
then
  shift
  plain_patchelf="1"
fi

elf="$1"
[[ -z "$1" ]] && exit 21
prefix=$(brew --prefix)

chmod +w "$elf"
if patchelf --print-interpreter "$elf" >/dev/null 2>&1
then
  interp=$(patchelf --print-interpreter "$elf")
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
  rpath=$( patchelf --force-rpath --print-rpath "$elf" | tr : '\n' | sed -e "s/@@HOMEBREW_PREFIX@@/${esc_prefix}/" | tr '\n' :)

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
