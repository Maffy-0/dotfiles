# ~/.zsh/functions.zsh

# パスを表示（存在しない場合は日本語メッセージ）
pass() {
  if [ -e "$1" ]; then
    realpath "$1"
  else
    echo "ファイルが見つかりません：$1"
  fi
}

# ランダムパスワード生成
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

