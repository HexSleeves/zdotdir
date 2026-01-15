# Terminal Optimization Guide

## ✅ Completed Configurations

All configuration files have been created and are ready to use. Here's what's been set up:

### New Configuration Files

1. **`conf.d/modern-tools.zsh`** - Modern CLI tool aliases and integrations
2. **`conf.d/fzf-enhanced.zsh`** - Enhanced fuzzy finder with previews and integrations
3. **`conf.d/performance.zsh`** - Shell performance optimizations
4. **`conf.d/atuin.zsh`** - Atuin shell history initialization
5. **`~/.config/atuin/config.toml`** - Atuin configuration
6. **`~/.gitconfig`** - Git configuration with delta and difftastic
7. **`~/.config/tmux/tmux.conf`** - Enhanced tmux configuration

### Updated Files

- **`conf.d/aliases.zsh`** - Updated to remove redundancies and add fallbacks

---

## 🚨 Required Action: Fix Xcode License

Before installing tools, you need to accept the Xcode license:

```bash
sudo xcodebuild -license accept
```

This is blocking both `brew install` and `cargo install` commands.

---

## 📦 Installation Steps

### Step 1: Accept Xcode License (Required!)

```bash
sudo xcodebuild -license accept
```

### Step 2: Install All Tools via Homebrew

```bash
brew install \
  atuin \
  dust \
  procs \
  hyperfine \
  tokei \
  tealdeer \
  duf \
  gping \
  lazygit \
  difftastic \
  tmux \
  xh \
  dog \
  hexyl \
  mosh
```

### Step 3: Update tldr Cache

```bash
tldr --update
```

### Step 4: Initialize Atuin

```bash
# Import your existing shell history
atuin import auto

# Optional: Set up sync (requires account)
# atuin register
# atuin login
```

### Step 5: Reload Shell

```bash
exec zsh
```

Or simply close and reopen your terminal.

---

## 🎯 What's Already Installed

You already have these modern tools installed:

- ✅ **ripgrep** (rg) 15.1.0 - Fast grep
- ✅ **fd** 10.3.0 - Fast find
- ✅ **bat** 0.26.1 - Cat with syntax highlighting
- ✅ **eza** 0.23.4 - Modern ls
- ✅ **jq** 1.8.1 - JSON processor
- ✅ **yq** - YAML processor
- ✅ **fzf** 0.67.0 - Fuzzy finder
- ✅ **delta** 0.18.2 - Git diff viewer
- ✅ **gh** 2.83.2 - GitHub CLI
- ✅ **zoxide** 0.9.8 - Smart cd
- ✅ **broot** - Tree navigator
- ✅ **bottom** (btm) - System monitor
- ✅ **sd** - sed alternative
- ✅ **procs** - Modern ps (via cargo)
- ✅ **hyperfine** - Benchmarking (via cargo)
- ✅ **tokei** - Code stats (via cargo)

---

## 🛠️ Tool Reference

### Modern Replacements

| Old Command | New Command | Fallback Alias |
|------------|-------------|----------------|
| `grep` | `rg` (ripgrep) | `ggrep` |
| `find` | `fd` | `ffind` |
| `ls` | `eza` | `l`, `ll`, `la` (if eza missing) |
| `cat` | `bat` | `ccat` |
| `du` | `dust` | `ddu` |
| `df` | `duf` | `ddf` |
| `ps` | `procs` | `pps` |
| `top`/`htop` | `btm` (bottom) | `ttop` |
| `curl` | `xh` | `ccurl` |
| `dig` | `dog` | `ddig` |
| `xxd` | `hexyl` | - |
| `sed` | `sd` | `ssed` |
| `ping` | `gping` | `pping` |
| `cd` | `z` (zoxide) | `ccd` |

### New Capabilities

- **`lazygit`** - Terminal UI for git (alias: `lg`)
- **`atuin`** - Shell history with search (Ctrl+R)
- **`tldr`** - Simplified man pages (alias: `help`)
- **`hyperfine`** - Benchmark commands (alias: `bench`)
- **`tokei`** - Code statistics (alias: `cloc`, `loc`)
- **`difftastic`** - Structural diff tool

---

## 🎨 FZF Enhanced Features

New key bindings and features:

### Built-in Bindings

- **Ctrl+T** - Fuzzy find files with bat preview
- **Alt+C** - Fuzzy find directories with eza tree preview
- **Ctrl+R** - History search (atuin takes over when installed)
- **Ctrl+/** - Toggle preview pane
- **Ctrl+Y** - Copy selected item to clipboard
- **Ctrl+E** - Open selected file in editor

### Custom Functions

- **`fzfgb`** or **Ctrl+G, B** - Fuzzy git branch switcher
- **`fzfgl`** or **Ctrl+G, L** - Fuzzy git log viewer
- **`fkill`** - Fuzzy process killer
- **`fenv`** - View environment variables
- **`fts`** - Tmux session selector (when tmux installed)
- **`fssh`** - SSH host selector
- **`fdocker`** - Docker container selector
- **`fkube`** - Kubernetes pod selector

---

## ⚡ Performance Improvements

### What's Been Optimized

1. **Lazy Loading** - NVM loads only when needed (~100-200ms saved)
2. **Compiled Config** - Zsh files auto-compile for faster loading
3. **Better History** - Optimized settings for 50,000 entries
4. **Keyboard Shortcuts** - Enhanced navigation and editing

### Benchmark Your Shell

```bash
# Quick benchmark (shows average)
zsh-bench

# Detailed benchmark with hyperfine
zsh-startup

# Manual benchmark
hyperfine --warmup 3 --runs 10 'zsh -lic exit'
```

**Target**: Under 100ms startup time

---

## 🎯 Git Enhancements

### Delta (Default Pager)

All `git diff`, `git show`, and `git log -p` now use delta automatically.

### Difftastic (Structural Diff)

Use for complex diffs:

```bash
git difftool              # Use difftastic
gdifft                    # Alias for difftastic
git difftool --staged     # For staged changes
```

### Useful Aliases

```bash
gst          # git status (short format)
glog         # Pretty git log with graph
lg           # Open lazygit UI
gdiff        # git diff with delta
gdifft       # git diff with difftastic
```

---

## 📝 Tmux Quick Reference

### Key Bindings (Prefix: Ctrl+A)

| Binding | Action |
|---------|--------|
| `Ctrl+A` `\|` | Split horizontal |
| `Ctrl+A` `-` | Split vertical |
| `Alt+Arrow` | Switch panes (no prefix!) |
| `Ctrl+A` `h/j/k/l` | Vim-style pane navigation |
| `Ctrl+A` `r` | Reload config |
| `Ctrl+A` `S` | Synchronize panes |
| `Ctrl+A` `c` | New window |
| `Ctrl+Shift+Arrow` | Switch windows (no prefix!) |

### Copy Mode (Vi-style)

1. `Ctrl+A` `[` - Enter copy mode
2. `v` - Start selection
3. `y` - Copy (to clipboard)
4. `Ctrl+A` `]` - Paste

---

## 🔧 Maintenance Commands

### Shell Maintenance

```bash
# Reload shell config
reload          # or: exec zsh

# Recompile zsh files for better performance
recompile-zsh

# Clean zsh cache
clean-zsh-cache

# Clean compiled files
clean-zsh-compiled
```

### Atuin Maintenance

```bash
# Search history
atuin search <query>
hs <query>              # Alias

# View statistics
atuin stats
hstats                  # Alias

# Sync (if enabled)
atuin sync
```

### Update Tools

```bash
# Update all Homebrew packages
brew upgrade

# Update specific tool
brew upgrade <tool-name>

# Update tldr cache
tldr --update
```

---

## 🎓 Learning Resources

### Quick Help

```bash
tldr <command>          # Quick examples
help <command>          # Alias for tldr
man <command>           # Traditional man pages (with bat syntax highlighting)
```

### Tool Documentation

- **ripgrep**: `rg --help` or visit <https://github.com/BurntSushi/ripgrep>
- **fd**: `fd --help` or visit <https://github.com/sharkdp/fd>
- **bat**: `bat --help` or visit <https://github.com/sharkdp/bat>
- **eza**: `eza --help` or visit <https://github.com/eza-community/eza>
- **fzf**: `fzf --help` or visit <https://github.com/junegunn/fzf>
- **atuin**: `atuin help` or visit <https://docs.atuin.sh>
- **lazygit**: `lg` then `?` for help, or visit <https://github.com/jesseduffield/lazygit>

---

## 🐛 Troubleshooting

### Tools Not Working?

1. **Check if installed:**

   ```bash
   which <tool-name>
   ```

2. **Check installation status:**

   ```bash
   for tool in atuin dust procs hyperfine tokei tldr duf gping lazygit difftastic tmux xh dog hexyl mosh; do
     echo -n "$tool: "
     command -v $tool &>/dev/null && echo "✓" || echo "✗"
   done
   ```

3. **Reinstall if needed:**

   ```bash
   brew reinstall <tool-name>
   ```

### Aliases Not Working?

1. **Reload shell:**

   ```bash
   exec zsh
   ```

2. **Check if config is sourced:**

   ```bash
   which lg  # Should show: lg: aliased to lazygit
   ```

3. **Verify config files loaded:**

   ```bash
   print -l $fpath  # Should include ~/.config/zsh/conf.d
   ```

### Shell Slow?

1. **Profile startup:**

   ```bash
   zsh-startup
   ```

2. **Check for slow plugins:**

   ```bash
   ZPROFRC=1 zsh
   # Then run: zprof
   ```

3. **Recompile configs:**

   ```bash
   recompile-zsh
   exec zsh
   ```

---

## 📊 Performance Comparison

### Before vs After

| Operation | Old Tool | New Tool | Speedup |
|-----------|----------|----------|---------|
| Text search | grep | ripgrep | 5-10x |
| File finding | find | fd | 3-5x |
| JSON parsing | cat + manual | jq | Instant |
| Process viewing | ps aux | procs | Clearer, faster |
| Directory navigation | cd | zoxide | Smarter |
| Git diff | git diff | delta/difftastic | Better readability |
| History search | Ctrl+R | atuin | Full-text fuzzy |

---

## 🎉 Next Steps

1. **Accept Xcode License** (if not done)

   ```bash
   sudo xcodebuild -license accept
   ```

2. **Install Missing Tools**

   ```bash
   brew install atuin dust tealdeer duf gping lazygit difftastic tmux xh dog hexyl mosh
   ```

3. **Initialize Atuin**

   ```bash
   atuin import auto
   ```

4. **Reload Shell**

   ```bash
   exec zsh
   ```

5. **Start Using!**
   - Try `lg` for lazygit
   - Use `Ctrl+R` for atuin history search
   - Use `z <directory>` for smart cd
   - Try `fzf` integrations

---

## 📚 Additional Notes

### Git Configuration

Your `.gitconfig` has been created with sensible defaults. You'll need to add your user info:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### Atuin Sync (Optional)

If you want to sync history across machines:

```bash
atuin register
atuin login
# Then enable sync in ~/.config/atuin/config.toml:
# auto_sync = true
```

### Tmux TPM (Optional)

For tmux plugin management, install TPM:

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Then uncomment plugin lines in `~/.config/tmux/tmux.conf` and press `Ctrl+A` `I` to install.

---

## 🤝 Feedback

All configurations follow modern best practices and are optimized for macOS. If you encounter any issues or want to customize further, all config files are well-documented with comments.

**Happy optimizing! 🚀**
