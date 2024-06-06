#!/usr/bin/env bash
set -eu

backup_dir="${HOME}/Sync/Backup/notes"
recipient="rmnull@eos"

if ! [[ -d "$backup_dir" ]]
then
    \mkdir -p "$backup_dir"
fi
notes_dir="${HOME}/notes"
readable_date=$(date '+%d-%b-%Y')
prefix=$(basename "${notes_dir}")
tarball_name="${prefix}-${readable_date}.tar.gz"
notes_tar="${backup_dir}/${tarball_name}"
encrypted_notes_tar="${notes_tar}.gpg"

remove_unecrypted_file() {
    [[ -e "$notes_tar" ]] && rm "$notes_tar"
}


trap remove_unecrypted_file INT ABRT QUIT

(
    cd "$(dirname "${notes_dir}")"
    tar -zcf "${notes_tar}" "$(basename "${notes_dir}")"
    [[ -e "$encrypted_notes_tar" ]] && rm "${encrypted_notes_tar}"
    gpg --recipient "$recipient" --output "${encrypted_notes_tar}" --encrypt "${notes_tar}"
)
remove_unecrypted_file

remote_copy() {
    local local_dir="$1"
    local remote_host="$2"
    local remote_dir;
    remote_dir="${3:-}" ; #$(basename "$local_dir")

    /usr/bin/env rsync -e "ssh -F '${HOME}/.ssh/config'" -aP "${local_dir}/" "${remote_host}":"${remote_dir}"
}
if ! remote_copy "$notes_dir" "pi-sync"
then
	echo "remote_copy failed" >&2
fi
