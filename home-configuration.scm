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
 (gnu services base)
 (gnu home services)
 (gnu home services shells)
 (ice-9 match)
 (ice-9 format))


;;; stolen from
;;; https://git.sr.ht/~whereiseveryone/confetti/tree/5f9d8b2e26918bb9e9cc9178435fc908cbf1af63/item/common.scm#L18

(define %conf-dir
  (dirname (current-filename)))

(define (path-join . args)
  (string-join args "/"))

(define (normalize-config-file-name output-name)
  (if (string= "." output-name 0 1 0 1)
      (string-drop output-name 1)
      output-name))

(define (config-file file)
  (local-file (path-join %conf-dir file)
              (normalize-config-file-name (basename file))))

(define normalize-config
  (match-lambda
    ((input . output)
     (list output
           (if (string? input)
               (config-file input)
               input)))
    (output (list output
                  (config-file (basename output))))))

(define %env-vars
  '(("GUIX_LOCPATH" . "${HOME}/.guix-home/profile/lib/locale")
    ("EDITOR" . "nvim")
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
    ("PYTHONDONTWRITEBYTECODE" . "1")))

(define %bash-aliases
  '(("l" . "eza --group-directories-first")
    ("ls" . "eza --group-directories-first")
    ("ll" . "eza --group-directories-first -l --no-permissions --octal-permissions")
    ("la" . "eza --group-directories-first -a")
    ("l1" . "eza --group-directories-first -1")
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
    ("ping" . "ping -w 4 -c 3")
    ("vim" . "nvim")))

(define %packages
  (list
    "alacritty"
    "adwaita-icon-theme" ;; required for some gnome tools to work as expected :(
    "bat"
    "beets"
    "bind"
    "curl"
    "docker"
    "docker-cli"
    "docker-compose"
    "eza"
    "emacs"
    "emacs-geiser"
    "gnome"
    "gnome-desktop"
    "git-delta"
    "gnupg"
    "guix"
    "guile"
    "iputils"
    "jq"
    "kmonad"
    "libnotify"
    "maven"
    "man-pages"
    "man-pages-posix"
    "mpv"
    "mupdf"
    "moka-icon-theme"
    "neovim"
    "nss-certs"
    "openssh"
    "papirus-icon-theme"
    "pinentry-tty"
    "pulseaudio"
    "python"
    "ripgrep"
    "rsync"
    ;"rust"
    ;"rust-cargo"
    "sed"
    "strace"
    "syncthing"
    ;"stumpwm"
    ;"sbcl-stumpwm-battery-portable"
    ;"sbcl-stumpwm-cpu"
    ;"sbcl-stumpwm-net"
    ;"sbcl-stumpwm-wifi"
    "sqlite@3.39.3"
    "tmux"
    ;;"xfce"
    "zoxide"))

;;; TODO: add .vim files inside nvim directory
;;; figure out how to copy recursively
(define %home-files
  `(("bash.guix/.inputrc" . ".inputrc")
;;; ugh need to move away from X
    ;; ("X/.xinitrc" . ".xinitrc")
    ;; ("X/.xmodmaprc" . ".xmodmaprc")
    ("dig/.digrc" . ".digrc")
    ("fd/.fdignore" . ".fdignore")
    ("git/.gitconfig" . ".gitconfig")
    ("git/.gitignore" . ".gitignore")
    ("rg/.ripgreprc" . ".ripgreprc")
    ("sqlite/.sqliterc" . ".sqliterc")
    ("stumpwm/.stumpwmrc" . ".stumpwmrc")
    ("tmux/.tmux.conf" . ".tmux.conf")))

(define %config-files
  `(;; ("mpd/.config/beets/" . "beets")
    ;; ("mpd/.config/mpd/" . "mpd")
    ;; ("ncmpcpp/.config/ncmpcpp/" . "ncmpcpp")
    ("python/.config/flake8" . "flake8")))


(home-environment
 ;; Below is the list of packages that will show up in your
 ;; Home profile, under ~/.guix-home/profile.
 (packages
  (append
    (specifications->packages %packages)))

 ;; Below is the list of Home services.  To search for available
 ;; services, run 'guix home search KEYWORD' in a terminal.
 (services
  (list
   (service home-bash-service-type
            (home-bash-configuration
             (environment-variables %env-vars)
             (aliases %bash-aliases)
             (bashrc
              (list
               (local-file "./bash.guix/.bashrc"
                           "bashrc")))
             (bash-profile
              (list
               (local-file
                "./bash.guix/.bash_profile"
                "bash_profile")))
             (bash-logout
              (list
               (local-file
                "./bash.guix/.bash_logout"
                "bash_logout"))) ))
   (service home-files-service-type
            (map normalize-config %home-files))
   (service home-xdg-configuration-files-service-type
            (map normalize-config %config-files)))))
