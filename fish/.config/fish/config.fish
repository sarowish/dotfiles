set fish_greeting ""
set -x MANPAGER 'nvim +Man!'

abbr ip 'ip -c'
abbr clock 'tty-clock -sc'
abbr neovim nvim
abbr n nvim
abbr mix pulsemixer
abbr neofetch hyfetch
abbr bw bawa
abbr zatt 'zathura --fork'

zoxide init fish | source
starship init fish | source
skim_key_bindings
