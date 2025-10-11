# ~/.zsh/env.zsh

# PATH
export PATH="$HOME/.local/bin:$PATH"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# 例：エディタ設定を使いたい場合はコメントアウトを外す
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# 例：言語環境
# export LANG=en_US.UTF-8

# 例：MANPATH
# export MANPATH="/usr/local/man:$MANPATH"

