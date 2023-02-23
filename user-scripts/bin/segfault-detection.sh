#!/usr/bin/env bash
#
# Usage: ./segfault-detection.sh <path-to-exec>
#
# The script was put together for batch processing,
# better off not used.
#
prg="$1"

if ! patchelf --print-interpreter "$prg"
then
  exit 0
fi

seg_logf="/tmp/segfault.log"
logf=$(echo "$prg" | sed -e 's/\// ; /g')
logf="/home/rmnull/dump/builds/elfs/.log/$logf"

"$prg" >"${logf}.out" 2>"${logf}.err" &
pid="$!"

# segmentation is supposed to happen quick, maybe there's no need to sleep
sleep 0.2

if kill -0 "$pid" >/dev/null 2>/dev/null
then
  exit 0
else

  # output already logged above
  "$prg" >/dev/null 2>/dev/null </dev/null
  ec="$?"

  echo -e "$ec $prg" >>/tmp/ec.log

  # 139 = SIGSEGV
  [[ $ec -eq 139 ]] && echo "$prg" >>"$seg_logf" || exit 0
fi

