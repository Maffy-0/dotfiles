# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=rkj-repos-24h""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=~/project/myzsh

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-completions zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias sz='du -sh "$@"'

export PATH="$HOME/.local/bin:$PATH"

alias fc='ls -1 | wc -l'

pass() {
  if [ -e "$1" ]; then
    realpath "$1"
  else
    echo "ファイルが見つかりません：$1"
  fi
}
export PATH="/Library/TeX/texbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

resizemp4() {
    if [ $# -ne 2 ]; then
        echo "Usage: resizemp4 input.mp4 output.mp4"
        return 1
    fi

    ffmpeg -i "$1" \
    -vf scale=1280:720 -c:v hevc_videotoolbox -b:v 2500k \
    -tag:v hvc1 -pix_fmt yuv420p -movflags +faststart -an \
    "$2"
}

alias dirstat='total=0; for d in */; do echo -n "$d "; val=$(cd "$d" && fc); echo "$val"; total=$((total + val)); done; echo "Total: $total"'

genpass() {
  local len=16
  local use_digits=1
  local use_symbols=1

  if [[ "$1" == "help" ]]; then
    cat <<'EOF'
Usage: genpass [options] [length]

Options:
  -ns    exclude digits
  -ni    exclude underscore

Examples:
  genpass          → 16 characters, includes digits and underscore
  genpass 12       → 12 characters, includes digits and underscore
  genpass -ns 12   → 12 characters, no digits
  genpass -ni 20   → 20 characters, no underscore
  genpass -ns -ni 8→ 8 characters, only upper and lowercase letters
EOF
    return 0
  fi

  while [[ "$1" == -* ]]; do
    case "$1" in
      -ns) use_digits=0 ;;
      -ni) use_symbols=0 ;;
      *) echo "Invalid option: $1 (use 'genpass help' for usage)" >&2; return 1 ;;
    esac
    shift
  done

  if [[ -n "$1" ]]; then
    len="$1"
  fi

  local chars="A-Za-z"
  (( use_digits )) && chars="${chars}0-9"
  (( use_symbols )) && chars="${chars}_"

  local p
  while :; do
    p="$(LC_ALL=C tr -dc "$chars" </dev/urandom | head -c "$len")"
    [ "${#p}" -eq "$len" ] || continue

    printf '%s' "$p" | grep -Eq '[A-Z]' || continue
    printf '%s' "$p" | grep -Eq '[a-z]' || continue
    (( use_digits )) && { printf '%s' "$p" | grep -Eq '[0-9]' || continue; }
    (( use_symbols )) && { printf '%s' "$p" | grep -F '_' >/dev/null || continue; }

    printf '%s\n' "$p"
    break
  done
}


convertm4a() {
  if [ -z "$1" ]; then
    echo "使い方: convertm4a input.m4a [output.mp3]"
    return 1
  fi

  input="$1"
  output="${2:-${input%.m4a}.mp3}"

  ffmpeg -i "$input" -codec:a libmp3lame -b:a 192k "$output"
  echo "変換完了: $output"
}

resizeimg() {
    if [ $# -lt 1 ]; then
        echo "Usage: resizeimg <input_file> [-s size]"
        echo "Example: resizeimg image.jpg -s 480"
        return 1
    fi
    local input="$1"
    shift
    local size=720
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -s|--size)
                size="$2"
                shift 2
                ;;
            *)
                echo "Unknown option: $1"
                return 1
                ;;
        esac
    done
    local filename=$(basename -- "$input")
    local extension="${filename##*.}"
    local name="${filename%.*}"
    local output="${name}_${size}p.${extension}"
    ffmpeg -y -i "$input" -vf "scale=-1:${size}:force_original_aspect_ratio=decrease" "$output"
}


converttopdf() {
    if [ $# -ne 2 ]; then
        return 1
    fi
    input="$1"
    output="$2"
    if [ ! -f "$input" ]; then
        return 1
    fi
    convert "$input" "$output"
}
