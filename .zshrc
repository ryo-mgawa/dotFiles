# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/miyagawaryouta/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/miyagawaryouta/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/miyagawaryouta/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/miyagawaryouta/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# alias 任意のコマンド='基のコマンド'
alias l='eza -a'
alias lg='lazygit'
alias aider='aider --no-auto-commits'
# alias ccu='tmux new -s claude-co \
#   \; split-window -h \
#   \; split-window -v \
#   \; select-pane -t 0 \
#   \; split-window -v \; select-pane -t 0'
# alias tcu='tmux send-keys -t 1 C-c && sleep 0.5 && tmux send-keys -t 1 "claude" C-m && tmux send-keys -t 2 C-c && sleep 0.5 && tmux send-keys -t 2 "claude" C-m && tmux send-keys -t 3 C-c && sleep 0.5 && tmux send-keys -t 3 "claude" C-m && claude'
# alias tcd='tmux send-keys -t 3 C-c && sleep 0.3 && tmux send-keys -t 3 C-c && sleep 0.5 && tmux send-keys -t 3 "exit" C-m && tmux send-keys -t 2 C-c && sleep 0.3 && tmux send-keys -t 2 C-c && sleep 0.5 && tmux send-keys -t 2 "exit" C-m && tmux send-keys -t 1 C-c && sleep 0.3 && tmux send-keys -t 1 C-c && sleep 0.5 && tmux send-keys -t 1 "exit" C-m'
alias ccusage='npx ccusage@latest'
alias c='claude --mcp-config ~/.claude/mcp_settings.json'
alias cdang='claude --dangerously-skip-permissions --mcp-config ~/.claude/mcp_settings.json'

eval "$(nodenv init -)"
export PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:$PATH"
export OPENAI_API_KEY=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
export AIDER_MODEL=gpt-4o
alias aider='aider --no-auto-commits'

# ~/.zshrc あるいは ~/.bash_profile に追記
export PATH="$(npm bin -g):$PATH"

# 反映
source ~/.zshrc        # または source ~/.bash_profile
