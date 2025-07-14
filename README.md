# Dotfiles

## Prerequisite Software

- [homebrew](https://brew.sh/)
  - install with `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- [git-delta](https://dandavison.github.io/delta/installation.html)
    - install with `brew install git-delta`

## Dev software

- [n](https://github.com/tj/n)
  - install with `brew install n`
- [yarn](https://yarnpkg.com/)
  - install with `npm install -g yarn`
- [node](https://nodejs.org/)
  - install with `n latest`
- [typescript](https://www.typescriptlang.org/)
  - install with `npm install -g typescript`
- [bun](https://bun.sh/)
   - install with `brew install oven-sh/bun/bun`
- [fish](https://fishshell.com/)
  - install with `brew install fish`
- [fisher](https://github.com/jorgebucaran/fisher)
  - install with `curl -sL
  https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish
  | source && fisher install jorgebucaran/fisher`
- [tide](https://github.com/IlanCosman/tide)
  - install with `fisher install IlanCosman/tide@v6`
  - configure with `tide configure --auto --style=Lean --prompt_colors='True color' --show_time='24-hour format' --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icon
s='Many icons' --transient=Yes`
- [neovim](https://neovim.io/)
  - install with `brew install neovim`

### Other brew binaries
- `tmux`
- `htop`
- `ripgrep`
- `tree`
- `fzf`
- `gh` (github cli)
- `bat`
- `lazydocker`

## CodeCompanion Setup

CodeCompanion is configured to use Anthropic's Claude API. To use it:

1. Set your Anthropic API key in your devcontainer.json:
   ```json
   {
     "containerEnv": {
       "ANTHROPIC_API_KEY": "${localEnv:ANTHROPIC_API_KEY}"
     }
   }
   ```
   Then set the environment variable locally:
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```

2. Key bindings:
   - `<C-a>` - Open CodeCompanion actions (normal/visual mode)
   - `<LocalLeader>a` - Toggle CodeCompanion chat (normal/visual mode)  
   - `ga` - Add selection to CodeCompanion chat (visual mode)
   - `:cc` - Expands to `:CodeCompanion` command

3. Usage:
   - `:CodeCompanion` - Open inline assistant
   - `:CodeCompanionChat` - Open chat interface
   - `:CodeCompanionActions` - Show available actions
