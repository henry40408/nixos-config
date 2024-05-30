reload() {
    exec zsh
}
export PATH="$HOME/.cargo/bin:$PATH"
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
