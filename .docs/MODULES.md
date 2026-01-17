# Modules

This repository uses a modular configuration system located in `conf.d/`. Files are loaded alphabetically.

## Core Modules

| File | Description |
|------|-------------|
| `__init__.zsh` | Core initialization, path setup, and essential options. Loaded first. |
| `aliases.zsh` | Standard shell aliases (git, ls, safe ops). |
| `functions.zsh` | Utility functions setup. |
| `history.zsh` | History file configuration (size, location, deduping). |
| `modern-tools.zsh` | Detects and aliases modern CLI replacements (eza, bat, rg, etc.). |
| `performance.zsh` | Performance optimizations and profiling tools. |
| `prompt.zsh` | Prompt initialization (Powerlevel10k). |

## Integrations

| File | Description |
|------|-------------|
| `atuin.zsh` | [Atuin](https://github.com/atuinsh/atuin) shell history integration. |
| `aws.zsh` | AWS CLI completions and helpers. |
| `fzf.zsh` | [fzf](https://github.com/junegunn/fzf) configuration and bindings. |
| `mise.zsh` | [mise](https://mise.jdx.dev) version manager setup. |
| `tmux.zsh` | Tmux configuration and aliases. |
| `vscode.zsh` | VS Code integration (shell integration). |
| `wezterm.zsh` | WezTerm shell integration. |
| `zoxide.zsh` | [zoxide](https://github.com/ajeetdsouza/zoxide) smart cd replacement. |

## Languages & Runtimes

| File | Description |
|------|-------------|
| `bun.zsh` | Bun JavaScript runtime. |
| `dotnet.zsh` | .NET Core / CLI. |
| `golang.zsh` | Go language path setup. |
| `java.zsh` | Java / JDK setup. |
| `node.zsh` | Generic Node.js setup. |
| `nvm.zsh` | Node Version Manager (alternative to mise). |
| `python.zsh` | Python, pip, and venv helpers. |
| `ruby.zsh` | Ruby and gem setup. |
| `rust.zsh` | Rust and Cargo path setup. |

## Custom & Misc

| File | Description |
|------|-------------|
| `ai-providers.zsh` | AI API configuration. |
| `dotfiles.zsh` | Utilities for managing this dotfiles repo. |
| `macos-paths.zsh` | macOS specific path additions. |
| `prj.zsh` | Project jumper configuration. |
