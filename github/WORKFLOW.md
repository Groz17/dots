# GitHub Actions Workflow Documentation

## Overview

This repository uses GitHub Actions to automatically tangle Org-mode files into configuration files.

## Triggers

The workflow runs on:

1. **Push to main** - When `.org` files or `tangle` script are modified
2. **Pull requests** - To validate changes before merging
3. **Manual trigger** - Via GitHub Actions UI (workflow_dispatch)
4. **Tags** - Creates releases when you push a version tag

## Workflow Steps

### 1. Setup
- Checks out repository
- Installs Emacs 29.4

### 2. Tangle
- Uses Emacs batch mode with `org-babel-tangle`
- Processes all `*[^|].org` files
- Generates tangle.log for debugging

### 3. Collect
- Parses org files to find `:tangle` directives
- Copies generated files to `tangled-output/`
- Creates `MANIFEST.txt` with list of files
- Adds `INFO.txt` with build metadata

### 4. Upload Artifact (every push)
- Uploads as workflow artifact
- Available for 30 days
- Named: `dotfiles-{commit-sha}`

### 5. Create Release (tags only)
- Creates `.tar.gz` archive
- Publishes as GitHub Release
- Includes installation instructions

## Creating a Release

### Semantic Versioning
```bash
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

### Date-based Versioning
```bash
git tag -a v$(date +%Y.%m.%d) -m "Release $(date +%Y-%m-%d)"
git push origin v$(date +%Y.%m.%d)
```

## Testing Before Release

1. Push changes to main branch
2. Wait for workflow to complete
3. Download artifact from Actions tab
4. Test configurations locally
5. If good, create a tag for release

## Troubleshooting

### Workflow fails at tangle step
- Check that org files have valid syntax
- Verify `:tangle` paths are correct
- Test locally with `./tangle`

### Tangled files not collected
- Ensure `:tangle` paths are absolute or start with `~/`
- Check `.github/scripts/collect-tangled.sh` parsing logic
- Verify files were actually created in `~/.config` etc.

### Release not created
- Ensure you pushed a tag: `git push origin v1.0.0`
- Check tag matches pattern `v*`
- Verify `GITHUB_TOKEN` has permissions (automatic)

## Manual Collection

You can test the collection script locally:

```bash
# Tangle files
./tangle

# Collect them
./.github/scripts/collect-tangled.sh output/

# Check what was collected
ls -la output/
cat output/MANIFEST.txt
```

## Customization

### Change retention period
Edit `.github/workflows/tangle.yml`:
```yaml
retention-days: 30  # Change to desired days (1-90)
```

### Add validation step
Before the tangle step, add:
```yaml
- name: Validate org files
  run: |
    # Add validation commands
```

### Exclude files from collection
Edit `.github/scripts/collect-tangled.sh` to filter paths.
