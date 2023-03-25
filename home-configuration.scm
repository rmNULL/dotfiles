;; This "home-environment" file can be passed to 'guix home reconfigure'
;; to reproduce the content of your profile.  This is "symbolic": it only
;; specifies package names.  To reproduce the exact same profile, you also
;; need to capture the channels being used, as returned by "guix describe".
;; See the "Replicating Guix" section in the manual.

(use-modules
 (gnu home)
 (gnu packages)
 (guix gexp)
 (gnu services)
 (gnu home services shells))

(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages
  (specifications->packages
   (list
    "alacritty"
    "bat"
    "beets"
    "curl"
    "docker"
    "docker-cli"
    "docker-compose"
    "exa"
    "fd"
    "fzf"
    "git"
    "glibc-locales"
    "gnome"
    "gnome-desktop"
    "gnupg"
    "guix"
    "iputils"
    "mpv"
    "neovim"
    "nss-certs"
    "openssh"
    "openssh"
    "pulseaudio"
    "ripgrep"
    "rsync"
    "zoxide"
    )))
 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (list
   (service home-bash-service-type
            (home-bash-configuration
             (environment-variables
              '(("EDITOR" . "nvim")
                ("FZF_CTRL_T_COMMAND" . "fd . -0")
                ("FZF_CTRL_T_OPTS" . "--read0")
                ("GPG_TTY" . "$(tty)")
                ;; overwrite duplicate history, don't add commands starting with space to history
                ("HISTCONTROL" . "erasedups:ignorespace")
                ;; The maximum number of lines contained in the history file, refer bash(1)
                ("HISTFILESIZE" . "12288")
                ;; The number of commands to remember in the command history, refer bash(1)
                ("HISTSIZE" . "11264")
                ("PATH" . "${HOME}/bin:${HOME}/.local/bin:${PATH}")
                ("PYTHONDONTWRITEBYTECODE" . "1")
                ))
             (aliases
              '(("l" . "exa --group-directories-first")
                ("ls" . "l")
                ("ll" . "ls -l --no-permissions --octal-permissions")
                ("la" . "ls -a")
                ("l1" . "ls -1")
                ("cat" . "bat")
                ("g" . "git")
                ("gx" . "guix")
                ("gxh" . "guix help")
                ("gxi" . "guix install")
                ("gxp" . "guix package")
                ("gxq" . "guix search")
                ("gxs" . "guix shell")
                ("gxu" . "guix pull")
                ("gxdl" . "guix download")
                ("gxrm" . "guix remove")
                ("mkdir" . "mkdir -p")
                ("c." . "cd ../")
                ("c.." . "cd ../../")
                ("c..." . "cd ../../../")
                ("c1." . "c.")
                ("c2." . "c..")
                ("c3." . "c...")
                ("c4." . "cd ../../../../")
                ("c5." . "cd ../../../../../")
                ("c6." . "cd ../../../../../../")
                ("c7." . "cd ../../../../../../../")
                ("c8." . "cd ../../../../../../../../")
                ("c9." . "cd ../../../../../../../../../")
                ("+r" . "chmod +r")
                ("+w" . "chmod +w")
                ("+x" . "chmod +x")
                ("r-" . "chmod -r")
                ("w-" . "chmod -w")
                ("x-" . "chmod -x")
                ("tmp" . "pushd /tmp")
                ("ping" . "ping -w 4 -c 3")))
             (bashrc
              (list
               (local-file "./.bashrc"
                           "bashrc")))
             (bash-profile
              (list
               (local-file
                "./.bash_profile"
                "bash_profile")))
             (bash-logout
              (list
               (local-file
                "./.bash_logout"
                "bash_logout"))))))))