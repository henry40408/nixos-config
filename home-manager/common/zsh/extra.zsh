reload() {
    exec zsh
}
decrypt() {
    eval "$(secrets decrypt environment)"
}
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
