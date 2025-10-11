# ~/.zshrc

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="rkj-repos-24h"

# Plugins
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
source "$ZSH/oh-my-zsh.sh"

# Custom configs loader
for file in "$HOME/.zsh/"*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && case "$(basename "$file")" in
    _*) ;;               # "_" 始まりは読み込まない
    *) source "$file" ;;
  esac
done
unset file

