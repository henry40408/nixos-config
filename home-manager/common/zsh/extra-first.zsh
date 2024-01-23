# Uncomment the following line if pasting URLs and other text is messed up.
# shellcheck disable=SC2034
DISABLE_MAGIC_FUNCTIONS="true"

# https://github.com/romkatv/powerlevel10k/tree/bd0fa8a08f62a6e49f8a2ef47f5103fa840d2198#how-do-i-configure-instant-prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f "$HOME/.p10k.zsh" ]] && source $HOME/.p10k.zsh
