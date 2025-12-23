# Gemini Context: Zsh Configuration Project

This `GEMINI.md` provides context for the AI agent working within this personal Zsh configuration repository (`$ZDOTDIR`).

## Project Overview

This is a modular, performance-oriented Zsh configuration designed to provide a "Fish-like" user experience. It uses **Antidote** as the primary plugin manager and adheres to XDG Base Directory standards. The architecture is split into initialization, modular configuration snippets, autoloaded functions, and external plugins.

## Architecture

The configuration loading order is orchestrated by `.zshrc` and `.zshenv`.

### Directory Structure

*   **`.zshrc`**: The main entry point for interactive shells. It sets up paths, loads `antidote`, and sources files from `conf.d/`.
*   **`.zshenv`**: Sets environment variables (loaded for all shells).
*   **`.zsh_plugins.txt`**: The manifest file for Antidote plugins.
*   **`conf.d/`**: Modular configuration files (e.g., `aliases.zsh`, `node.zsh`, `prompt.zsh`). Sourced automatically by `.zshrc` after antidote.
    *   `__init__.zsh`: Runs first within `conf.d/` to set core paths and options.
*   **`functions/`**: Contains Zsh functions that are autoloaded (`autoload -Uz`). File names match function names.
*   **`custom/`**: A directory structure compatible with Oh-My-Zsh for local plugins, themes, and overrides.
*   **`lib/`**: Core helper scripts (e.g., `antidote.zsh` for bootstrapping the plugin manager).
*   **`bin/`**: Custom executable scripts, including the `repo` utility.

### Plugin Management

*   **Antidote**: The primary manager. Plugins are defined in `.zsh_plugins.txt` and loaded via `lib/antidote.zsh`.
*   **Repo Script**: A custom script located at `bin/repo` is used to manage git repositories manually, storing them in `$XDG_CACHE_HOME/repos`. This is used for dependencies not managed by Antidote.

## Building and Configuration

This project is a configuration environment, so "building" refers to reloading or updating the shell state.

### Key Commands

*   **Reload Shell**: `exec zsh` (or simply open a new terminal).
*   **Update Plugins**:
    *   For Antidote: `antidote update` (if the alias/function exists) or via manual git pulls in the plugin directory.
    *   For `repo` managed items: `bin/repo up`.
*   **Benchmark**: `zsh-bench` (external tool, seemingly integrated) is used to verify startup performance.

### Workflow Guidelines

1.  **Adding a Plugin**: Add the bundle reference to `.zsh_plugins.txt`.
2.  **Adding an Alias**: Add it to `conf.d/aliases.zsh` or a topic-specific file in `conf.d/` (e.g., `git.zsh`).
3.  **Adding a Function**: Create a new file in `functions/` with the same name as the function.
4.  **Customizing Prompt**: Configuration is in `conf.d/prompt.zsh`. The project appears to support `p10k` and `pure` themes.

## Development Conventions

*   **XDG Compliance**: Use `$ZSH_CONFIG_DIR`, `$ZSH_DATA_DIR`, and `$ZSH_CACHE_DIR` instead of hardcoded home paths.
*   **Modularity**: Avoid putting everything in `.zshrc`. Use `conf.d/` for topic-specific configs.
*   **Performance**: Avoid heavy initializations in the interactive path. Use `autoload` for functions.
*   **Style**: The code follows standard shell scripting practices. Comments should explain *why*, not just *what*.

## Key Files

*   `README.md`: General usage and installation instructions.
*   `CLAUDE.md`: Existing AI context file (contains valuable specific details on "repo" command and `custom/` structure).
*   `.zshrc`: Main loader.
*   `lib/antidote.zsh`: Bootstraps the plugin manager.
