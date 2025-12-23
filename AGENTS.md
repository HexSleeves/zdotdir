# AGENTS.md

## Build/Lint/Test Commands

This is a zsh configuration repository. Testing focuses on shell startup performance and syntax validation:

- `zsh -n <file>` - Syntax check zsh files without execution
- `zprofrc` - Profile shell startup performance (loads with ZPROFRC=1)
- `zbench` - Run 10 shell startup benchmarks 
- `zsh-bench` - External comprehensive benchmarking tool
- `rmzwc --dry-run` - Check for compiled .zwc files
- `zcompiledir <dir>` - Compile zsh files in directory

## Code Style Guidelines

### File Structure
- `conf.d/*.zsh` - Modular configuration, loaded alphabetically (~ prefix disables)
- `functions/` - One function per file, file name = function name
- `completions/` - Custom completion definitions
- Use `##?` comments for function help text

### Zsh Conventions
- Start functions with `emulate -L zsh; setopt local_options` for scoping
- Use XDG-compliant paths: `$ZSH_DATA_DIR`, `$ZSH_CACHE_DIR`
- Follow existing patterns: `ZSH_ENABLE_<NAME>=0` for optional modules
- Local configs in `conf.d/*.local.zsh` (git-ignored)
- Antidote for plugin management (static bundle list in `lib/antidote.zsh`)

### Imports & Dependencies
- Source files conditionally with `[[ -r $file ]] && source $file`
- Use `autoload -Uz` for function loading
- Set essential options early: `EXTENDED_GLOB INTERACTIVE_COMMENTS`

### Naming & Formatting
- Function names: lowercase with underscores, descriptive
- Variables: local scope, meaningful names
- Aliases: short but clear, follow existing patterns
- Error handling: check file existence before operations
- End config files with `true` to ensure success return