#!/usr/bin/env bash
set -u
program="${BASH_SOURCE}"
cwd=`dirname $program`

usage() {

cat <<HELP
Usage: $program [options]

options:
  --ask		Ask before overwriting
  --help	show this message
  --no-backup	Overwrite the dotfiles in HOME directory without creating a local backup
  --pretend	Don't copy, print the actions of running this commands
  --verbose	print the actions
HELP

}

backup=true
cp=cp
mkdir=mkdir

for arg in "$@"
do
	case $arg in
		--ask)
			cp="${cp} -i"
		;;
		--no-backup) backup=false
		;;
		--help)
			usage
			exit 0
		;;
		--pretend)
			cp="echo ${cp}"
			mkdir="echo ${mkdir}"
		;;
		--verbose)
			cp="${cp} --verbose"
			mkdir="${mkdir} --verbose"
		;;
		*)
			echo $program: invalid option -- $arg
			usage
			exit 1
		;;
	esac
done

if $backup
then
	bud=`mktemp -d -p $cwd dots-XXXX-bk`
fi

HOME="/tmp"

for src in *.conf *rc bash/* config/* vim/*
do
	if [[ -d $src ]]
	then dest="$HOME/.$src"
	else dest="$HOME/.`basename $src`"
	fi

	if [[ $backup && -e $dest ]]
	then
		(bk_file="$bud/$src"
		bk_dir=`dirname $bk_file`
		[[ ! -e $bk_dir ]] && $mkdir -p $bk_dir
		$cp -rT $dest $bk_file)
	fi

	[[ ! -d `dirname $dest` ]] && $mkdir -p `dirname $dest`

	$cp -rT $src $dest --strip-trailing-slashes
done

if $backup
then
	# trust rmdir to remove iff dir is empty
	rmdir $bud 2> /dev/null || echo -e "\E[1;35;47m"existing dotfiles copied to $bud"\E[0m"
fi
