# Dotfiles

## Setup prerequisites

When setting up a new machine, ensure the following are installed:

### Neovim
- Requires Neovim >= 0.10 (for nvim-lspconfig v2.x compatibility)
- Install via PPA: `sudo add-apt-repository -y ppa:neovim-ppa/unstable && sudo apt-get update && sudo apt-get install -y neovim`

### Language servers
- **C#**: `dotnet tool install --global csharp-ls` (requires `~/.dotnet/tools` on PATH)
- **TypeScript**: `npm install -g typescript-language-server typescript` (requires Node via nvm)

### Node.js (via nvm)
- Install nvm: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash`
- Install Node LTS: `nvm install --lts`

### PATH requirements
- `~/.dotnet/tools` must be on PATH for csharp-ls (handled in init.lua for nvim, but also add to shell rc)
