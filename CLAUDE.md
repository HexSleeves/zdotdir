# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal zsh configuration directory (`$ZDOTDIR`) forked from [mattmc3/zdotdir](https://github.com/mattmc3/zdotdir), designed to provide Fish-like behavior in zsh. The configuration uses Antidote for plugin management and a modular `conf.d/` architecture.

## Architecture

### Core Initialization Files

- **`.zshenv`** - Loaded first; sets `ZDOTDIR` and XDG base directories
- **`.zshrc`** - Loaded for interactive shells; initializes Antidote, loads `conf.d/`, sets up functions and completions
- **`.zstyles`** - Centralized `zstyle` configuration for Antidote, Zephyr, and editor plugins

### Plugin Management

The configuration uses **Antidote** (`lib/antidote.zsh`) for plugin management:
- Plugins are statically defined in `lib/antidote.zsh` via `antidote load`
- Bundled plugins are cached in `$XDG_CACHE_HOME/repos`
- Auto-compilation is enabled for fast loading

### Directory Structure

- **`conf.d/`** - Modular configuration files loaded alphabetically (files starting with `~` are skipped)
- **`functions/`** - Autoloaded shell functions (each file = one function, use `##?` for help comments)
- **`lib/`** - Supporting libraries (zsh-hooks, wezterm integration, zsh-no-ps2)
- **`completions/`** - Custom completion definitions
- **`.docs/`** - Zsh reference documentation and cheat sheets

### Optional Modules

Modules can be disabled by setting `ZSH_ENABLE_<NAME>=0` before shell starts:
- `ZSH_ENABLE_MISE` - mise version manager (`conf.d/mise.zsh`)
- `ZSH_ENABLE_NVM` - Node Version Manager (`conf.d/~nvm.zsh`)
- `ZSH_ENABLE_BUN` - Bun JavaScript runtime (`conf.d/bun.zsh`)
- `ZSH_ENABLE_FZF` - fzf fuzzy finder (`conf.d/fzf.zsh`)
- `ZSH_ENABLE_AWS` - AWS CLI (`conf.d/aws.zsh`)
- `ZSH_ENABLE_AI_PROVIDERS` - AI API keys (`conf.d/ai-providers.zsh`)

### Local Configuration Pattern

Secrets and machine-specific settings belong in `conf.d/*.local.zsh` files (git-ignored):
- Copy from `.example` files: `aws.local.zsh.example`, `ai-providers.local.zsh.example`
- These files are sourced automatically with `allexport` option

### Editor Configuration

Vi keybindings are enabled by default (`.zstyles`):
```zsh
zstyle ':zsh_custom:plugin:editor' key-bindings 'vi'
```
Custom extensions are enabled via:
```zsh
zstyle ':zsh_custom:plugin:editor:*' 'enabled' 'yes'
```

### Prompt System

Uses Powerlevel10k with instant prompt:
- Configured in `conf.d/prompt.zsh`
- Theme config in `.p10k.zsh`
- Instant prompt enabled for fast shell startup

### History Configuration

- Location: `$ZSH_DATA_DIR/.zsh_history` (XDG-compliant)
- Large history: `HISTSIZE=20000`, `SAVEHIST=20000`
- Settings: `INC_APPEND_HISTORY_TIME`, `EXTENDED_HISTORY`, `SHARE_HISTORY`, etc.

### History Substring Search

Custom key bindings in `conf.d/zsh-history-substring-search.zsh`:
- Vi mode: `k` (up), `j` (down)
- Emacs mode: `^P` (up), `^N` (down)
- Both modes: arrow keys

## Common Development Tasks

### Performance Testing

```zsh
# Benchmark with zsh-bench (external tool)
zsh-bench

# Simple exit timing
zbench  # alias for: for i in {1..10}; do /usr/bin/time zsh -lic exit; done

# Profile startup
zprofrc  # runs ZPROFRC=1 zsh
```

### Managing Functions

Functions are autoloaded from `functions/`:
- One function per file, named after the function
- Use `##?` comments for help text
- Use `emulate -L zsh; setopt local_options` for proper scoping

### Adding Configuration

Add new files to `conf.d/`:
- Prefix with `~` to disable (e.g., `~module.zsh`)
- Use `ZSH_ENABLE_<NAME>` pattern for optional modules
- Follow existing patterns for conditional loading

### Cleaning Compiled Files

```zsh
# Remove zwc files
rmzwc

# Dry run
rmzwc --dry-run

# Compile a directory
zcompiledir /path/to/dir
zcompiledir -c /path/to/dir  # clean only
```

## XDG Base Directory Compliance

All paths follow XDG standards:
- `XDG_CONFIG_HOME` (default: `~/.config`)
- `XDG_CACHE_HOME` (default: `~/.cache`)
- `XDG_DATA_HOME` (default: `~/.local/share`)
- `XDG_STATE_HOME` (default: `~/.local/state`)
- `XDG_PROJECTS_DIR` (default: `~/Projects`)

## Helper Variables

- `$ZSH_CONFIG_DIR` - `$ZDOTDIR` (defaults to `~/.config/zsh`)
- `$ZSH_DATA_DIR` - `$XDG_DATA_HOME/zsh`
- `$ZSH_CACHE_DIR` - `$XDG_CACHE_HOME/zsh`

## Key Aliases

- `zshrc` - Edit `.zshrc` in `$EDITOR`
- `nv` - Neovim shortcut
- `g` - Git shortcut
- `cls` - Clear screen with scrollback clear
