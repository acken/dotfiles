# Dotfiles

## Setup prerequisites

When setting up a new machine, ensure the following are installed:

### Neovim
- Requires Neovim >= 0.10 (for nvim-lspconfig v2.x compatibility)
- Install via PPA: `sudo add-apt-repository -y ppa:neovim-ppa/unstable && sudo apt-get update && sudo apt-get install -y neovim`

### Language servers

- **C#**: Run `bin/setup-csharp-lsp` — installs the .NET SDK and configures the Roslyn LSP.
  See [bin/setup-csharp-lsp](bin/setup-csharp-lsp) for details. The Roslyn LSP itself
  (`Microsoft.CodeAnalysis.LanguageServer`) is auto-installed by Neovim on first `.cs`
  file open via the `roslyn.nvim` plugin + mason, so the script mainly handles the
  system-level SDK install and `DOTNET_ROOT` configuration.
- **TypeScript**: `npm install -g typescript-language-server typescript` (requires Node via nvm)

### Node.js (via nvm)
- Install nvm: `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash`
- Install Node LTS: `nvm install --lts`

### C# LSP architecture (Roslyn)

The C# setup uses **Microsoft's official Roslyn Language Server** (same as VS Code's C# extension).
Previously used `csharp-ls` but it crashes on .NET 10 SDK with a `NullReferenceException` in
`ServerStateLoop`. OmniSharp was also tried but sends non-spec-compliant `null` messages that
newer Neovim rejects with `INVALID_SERVER_MESSAGE: vim.NIL`.

The Roslyn LSP is delivered via the `Crashdummyy/mason-registry` community mason registry,
which packages the `Microsoft.CodeAnalysis.LanguageServer` NuGet package. The `seblj/roslyn.nvim`
plugin handles attach/solution detection. Both plugins are in `init.lua`.

**Important:** `DOTNET_ROOT` must point at the system-wide .NET install location
(e.g. `/usr/lib/dotnet` on Ubuntu), **not** `~/.dotnet` (that's only a tool store, no
runtime lives there). This is set in both `init.lua` (for nvim) and `.zshrc` (for the shell).

### PATH / env requirements
- `~/.dotnet/tools` on PATH for `dotnet tool` global tools
- `DOTNET_ROOT=/usr/lib/dotnet` (or wherever your system .NET is) — required for Roslyn LSP
  to locate MSBuild and the runtime
