# ~/.zsh/aliases.zsh

alias fc='ls -1 | wc -l'

alias dirstat='total=0; for d in */; do echo -n "$d "; val=$(cd "$d" && fc); echo "$val"; total=$((total + val)); done; echo "Total: $total"'

alias sz='du -sh "$@"'

