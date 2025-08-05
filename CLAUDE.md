# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal zsh configuration directory (`$ZDOTDIR`) designed to provide Fish-like behavior in zsh. The configuration is modular and organized with a plugin-based architecture.

## Directory Structure & Architecture

### Core Directories

- **`conf.d/`** - Configuration initialization files loaded before plugins
- **`custom/`** - Custom plugins, aliases, functions, and themes (Oh-My-Zsh compatible)
- **`functions/`** - Custom shell functions (auto-loaded)

### Plugin System

The configuration uses a custom plugin system that's Oh-My-Zsh compatible:

1. **Plugin Loading**: Plugins are stored in `custom/plugins/` and loaded via zstyle configuration
2. **Plugin Structure**: Each plugin has a `.plugin.zsh` file and marks itself as loaded with `zstyle ':zsh_custom:plugin:PLUGINNAME' loaded 'yes'`
3. **External Repos**: External repositories are managed via the `repo` command using `custom/repos.txt`

### Key Architecture Components

- **`custom/lib/__init__.zsh`** - Core initialization, XDG directory setup, plugin management functions
- **`conf.d/__init__.zsh`** - Early initialization, PATH/CDPATH setup, environment variables
- **`custom/repos.txt`** - External repository manifest for dependency management
- **Plugin Extensions** - Editor plugin supports extensions in `extensions/` subdirectory

## Common Development Tasks

### Testing Performance
```zsh
# Benchmark shell startup time
zsh-bench

# Simple exit timing test  
zbench
```

### Managing External Dependencies
```zsh
# Install/update external repos from repos.txt
repo in <custom/repos.txt
```

### Plugin Development

When creating new plugins:
1. Create directory in `custom/plugins/PLUGINNAME/`
2. Create `PLUGINNAME.plugin.zsh` file
3. End plugin with: `zstyle ':zsh_custom:plugin:PLUGINNAME' loaded 'yes'`
4. Use conditional loading: `if ! zstyle -t ':zsh_custom:plugin:PLUGINNAME:feature' skip; then`

### Function Management

Functions are auto-loaded from the `functions/` directory. Each function should:
- Be in its own file named after the function
- Include `##?` comments for help text
- Use `emulate -L zsh; setopt local_options` for proper scoping

## Configuration Patterns

### Zstyle Configuration System
The configuration uses zstyle extensively for feature toggling:
```zsh
# Check if feature should be skipped
if ! zstyle -t ':zsh_custom:plugin:git:alias' skip; then
  # Define aliases
fi

# Enable/disable editor extensions
zstyle ':zsh_custom:plugin:editor:EXTENSION' enabled yes
```

### XDG Base Directory Compliance
All configurations follow XDG standards:
- `XDG_CONFIG_HOME` (default: `~/.config`)
- `XDG_CACHE_HOME` (default: `~/.cache`) 
- `XDG_DATA_HOME` (default: `~/.local/share`)
- `XDG_STATE_HOME` (default: `~/.local/state`)

### Cached Evaluation
Use `cached-eval` function for expensive command outputs that don't change frequently (caches for 20 hours).

## Key Files to Understand

- **`custom/myaliases.zsh`** - Personal aliases and shortcuts
- **`custom/myfuncs.zsh`** - Custom utility functions
- **`custom/plugins/git/git.plugin.zsh`** - Git aliases and completion setup
- **`custom/plugins/editor/editor.plugin.zsh`** - Line editor configuration with keymap management

## Development Notes

- Plugins mark themselves as loaded using zstyle for tracking
- Use `is-callable`, `is-true`, `is-macos` helper functions for conditionals
- The `repo` command manages external dependencies from GitHub
- Performance is regularly monitored with `zsh-bench`
- Configuration supports both emacs and vi key bindings via editor plugin