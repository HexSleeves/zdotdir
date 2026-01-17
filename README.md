# Zsh Configuration (`$ZDOTDIR`)

A modular, performance-oriented Zsh configuration designed to provide a "Fish-like" user experience. It uses **Antidote** as the primary plugin manager and adheres to XDG Base Directory standards.

## Overview

This configuration is built with three core goals:
1.  **Performance**: Fast startup times using lazy-loading and compiled modules.
2.  **Modularity**: Configuration is split into topic-specific files in `conf.d/`.
3.  **Modernity**: Prefers modern Rust-based CLI tools (e.g., `eza`, `bat`, `ripgrep`) over legacy Unix commands.

## Installation

### Prerequisites
- Zsh
- Git
- [Nerd Fonts](https://www.nerdfonts.com/) (recommended for prompt and icons)

### Setup
1.  Clone the repository to your preferred location (typically `~/.config/zsh`):
    ```zsh
    export ZDOTDIR=~/.config/zsh
    git clone --recursive git@github.com:mattmc3/zdotdir.git $ZDOTDIR
    ```

2.  Point your shell to this directory by adding this to `~/.zshenv`:
    ```zsh
    echo 'export ZDOTDIR=~/.config/zsh' >> ~/.zshenv
    echo '[[ -f $ZDOTDIR/.zshenv ]] && . $ZDOTDIR/.zshenv' >> ~/.zshenv
    ```

3.  Restart your shell or run `exec zsh`.

## Architecture

The configuration loading order is orchestrated by `.zshrc`:

1.  **`.zshenv`**: Sets environment variables and XDG base directories.
2.  **`.zshrc`**: Initializes the shell, loads Antidote, and sources modules.
3.  **`conf.d/__init__.zsh`**: Sets up core paths and options.
4.  **`lib/antidote.zsh`**: Loads plugins defined in `.zsh_plugins.txt`.
5.  **`conf.d/*.zsh`**: Loads remaining configuration modules alphabetically.

### Directory Structure
- **`conf.d/`**: Modular configuration files (aliases, language setups, tool integrations).
- **`functions/`**: Autoloaded Zsh functions. File names match function names.
- **`lib/`**: Core libraries and helper scripts.
- **`bin/`**: Custom executable scripts.
- **`custom/`**: Local overrides and plugins (Oh-My-Zsh compatible structure).

## Configuration

### Enabling/Disabling Modules
Modules in `conf.d/` can be selectively enabled or disabled using environment variables in `.zshenv` or before `zsh` starts.

Common feature toggles:
- `ZSH_ENABLE_MISE`: Enable [mise](https://mise.jdx.dev) version manager.
- `ZSH_ENABLE_NVM`: Enable Node Version Manager.
- `ZSH_ENABLE_BUN`: Enable Bun runtime.
- `ZSH_ENABLE_FZF`: Enable fzf integration.
- `ZSH_ENABLE_AWS`: Enable AWS CLI completions and helpers.
- `ZSH_ENABLE_AI_PROVIDERS`: Enable AI API configurations.

### Local Customization
**Do not modify tracked files for local secrets.** Instead, use the `*.local.zsh` pattern in `conf.d/`. These files are ignored by git.

Example: To add AWS keys, copy the example and edit:
```zsh
cp conf.d/aws.local.zsh.example conf.d/aws.local.zsh
# Edit conf.d/aws.local.zsh with your secrets
```

### Modern Tools (`modern-tools.zsh`)
If installed, modern replacements are automatically aliased:
- `ls` -> `eza`
- `cat` -> `bat`
- `grep` -> `rg`
- `find` -> `fd`
- `cd` -> `zoxide` (via `z` alias)
- `du` -> `dust`
- `df` -> `duf`

## Utilities

### Included Scripts (`bin/`)
- **`repo`**: A lightweight git repository manager.
    - `repo in < list.txt`: Install repositories from a list.
    - `repo up`: Update all repositories in `$XDG_CACHE_HOME/repos`.
    - `repo ls`: List managed repositories.
- **`prj`**: A project jumper to quickly navigate between projects.

### Autoloaded Functions (`functions/`)
- **`clone <user>/<repo>`**: Smart wrapper for `git clone` that organizes projects into `$XDG_PROJECTS_DIR`.
- **`cdpr`**: `cd` to the Project Root of the current git repository.

## Key Bindings
- **Vi Mode**: Enabled by default.
- **History Search**:
    - `Up`/`Down`: Fuzzy search history based on current command line prefix.
    - `k`/`j` (in normal mode): Same as above.

## Documentation
For more detailed information, check the `.docs/` directory or the comments within specific `conf.d/` files.