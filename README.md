# Dotfiles

Literate programming approach to system configuration using Org-mode.

## Advantages of Literate Programming

- Document complex configurations with explanations
- Support for file types without comments (e.g., JSON)
- Generate code with loops and templates (DRY principle)
- Single source of truth for related configurations

## Usage

### Prerequisites

- Emacs (with org-mode)

### Local Development

Tangle all org files to generate configuration files:

```bash
./tangle
```

Tangle specific files:

```bash
./tangle bash.org zsh.org
```

**Note**: A Neovim-based version is available as `tangle.nvim.bak` if needed.

### Automated Builds

This repository uses GitHub Actions to automatically tangle configurations:

- **On every push**: Tangled files are uploaded as workflow artifacts (available for 30 days)
- **On tagged releases**: Creates a GitHub release with `dotfiles.tar.gz`

### Downloading Configurations

**Latest build** (for testing):
1. Go to [Actions](../../actions)
2. Click on the latest successful workflow run
3. Download the `dotfiles-*` artifact

**Stable release**:
```bash
# Download latest release
curl -L https://github.com/Groz17/dots/releases/latest/download/dotfiles.tar.gz | tar xz

# Or specific version
curl -L https://github.com/Groz17/dots/releases/download/v1.0.0/dotfiles.tar.gz | tar xz
```

### Creating a Release

```bash
# Tag a new version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# GitHub Actions will automatically create a release with tangled files
```

## File Naming Convention

- `*.org` - Source files (literate programming)
- `*|.org` - Files excluded from default tangling
- `_*.org` - (convention to be documented)

## Structure

```
.
├── *.org              # Org-mode source files
├── tangle             # Local tangling script
├── .github/
│   ├── workflows/     # CI/CD automation
│   └── scripts/       # Helper scripts
└── README.md
```

## Contributing

Edit the `.org` files, not the generated configuration files. The tangled outputs are ephemeral build artifacts.
