# dotfiles
Personal configuration files.
Living in this "stateless" state of imperfection.

These configs have been cobbled together from various sources.
Wherever possible, I’ve tried to credit the sources. If I’ve missed anything, it’s unintentional, feel free to point it out.

[Guix](https://guix.gnu.org/) manages my home for me, and it’s all declared in this one sweet file.  
If you’re unfamiliar with Guix, do yourself a favor and [check it out](https://guix.gnu.org/).

Oh, and [my Emacs setup](https://github.com/rmnull/emacs.d/) lives just in the neighborhood. Since you’re here, go give it a visit.

## Try it out
```sh
make dry-run
```
This puts you in a container and a sneak peek of what you are about to get, without actually touching anything on your system[^1]   
Once you’re satisfied, take the leap
```sh
make re
```
This will initialize the guix home place the configs in your home directory.
There are few odd things that are yet to be done.

## Oddities
### Kmonad
  I manually load this configurations after the system is booted.
  Since i rarely restart my system this hasn't been a big deal breaker for me.
### Vim
  My (Neo)Vim configuration is not linked by the Guix home as I no longer use
  it except for one or two small quick edits and the default setup is good enough
  to let me pass by.
### Emacs
  My Emacs Configuration is also something that is not managed by Guix. Since I was
  heavily reliant on Emacs for my day to day tasks. I didn't want to jeopardize it
  when switching to Guix home. Now that I'm used to Guix home. I should
  link it.


## LICENSE
  Guthrie (modified) Public License  
Anybody caught forkin it without our permission,  
will be mighty good friends of ourn,  
cause we don't give a dern.  
    Publish it.  
    Write it.  
    Fork it.  
    Yodel it.  
    That's all we wanted to do.

[^1]: Not meant to be taken literally.
