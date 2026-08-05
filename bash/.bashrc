# managed by dotfiles (stow bash); machine-local additions go in
# ~/.config/shell/local.sh (untracked), not here

case $- in *i*) ;; *) return ;; esac

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize globstar

[ -x /usr/bin/dircolors ] && eval "$(dircolors -b)"

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

for f in "$HOME"/.config/shell/*.sh; do
  [ -r "$f" ] && . "$f"
done
[ -r "$HOME/.config/shell/local.sh" ] || true
