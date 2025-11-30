#!/usr/bin/env bash
# Collect tangled files based on org file headers

set -euo pipefail

OUTPUT_DIR="${1:-tangled-output}"
mkdir -p "$OUTPUT_DIR"

echo "Collecting tangled configuration files..."

# Function to extract tangle paths from org files
extract_tangle_paths() {
    local org_file="$1"
    
    # Look for :tangle property in header-args
    grep "^#\\+property: header-args :tangle" "$org_file" | \
        sed 's/.*:tangle //' | \
        sed 's/^~//g' | \
        sed "s|^|$HOME|"
    
    # Also look for individual :tangle directives in source blocks
    grep "^#\\+begin_src.*:tangle" "$org_file" | \
        sed 's/.*:tangle //' | \
        awk '{print $1}' | \
        sed 's/^~//g' | \
        sed "s|^|$HOME|"
}

# Collect all tangled file paths
declare -A tangled_files

for org_file in *[!\|].org; do
    [ -f "$org_file" ] || continue
    
    echo "Processing $org_file..."
    
    while IFS= read -r tangle_path; do
        [ -z "$tangle_path" ] && continue
        
        # Expand path
        expanded_path=$(eval echo "$tangle_path")
        
        if [ -f "$expanded_path" ]; then
            tangled_files["$expanded_path"]=1
            echo "  Found: $expanded_path"
        fi
    done < <(extract_tangle_paths "$org_file")
done

# Copy files preserving structure relative to HOME
echo -e "\nCopying files to $OUTPUT_DIR..."

for file in "${!tangled_files[@]}"; do
    # Get path relative to HOME
    rel_path="${file#$HOME/}"
    
    # If file is not under HOME, use absolute path structure
    if [ "$rel_path" = "$file" ]; then
        rel_path="${file#/}"
    fi
    
    dest="$OUTPUT_DIR/$rel_path"
    mkdir -p "$(dirname "$dest")"
    
    cp "$file" "$dest"
    echo "  Copied: $rel_path"
done

# Create manifest
echo -e "\nCreating manifest..."
(cd "$OUTPUT_DIR" && find . -type f | sort) > "$OUTPUT_DIR/MANIFEST.txt"

echo -e "\nDone! Collected ${#tangled_files[@]} files."
echo "Output directory: $OUTPUT_DIR"
