#!/usr/bin/env bash
set -euo pipefail
dir="${1:?usage: verify-images.sh <image-directory>}"
shopt -s nullglob
images=("$dir"/*wr841hp*v3*.bin)
if [ ${#images[@]} -eq 0 ]; then
  echo "::error::No image named for TL-WR841HP v3 found. Refusing to publish unrelated images."
  exit 1
fi

# Conservative ceiling below nominal 8 MiB flash; actual image recipe/partition
# limits can be smaller, so this is only a guardrail, not proof of fit.
limit=$((8 * 1024 * 1024))
for img in "${images[@]}"; do
  size=$(stat -c '%s' "$img")
  sha=$(sha256sum "$img" | awk '{print $1}')
  echo "$img size=$size sha256=$sha"
  if [ "$size" -ge "$limit" ]; then
    echo "::error::Image is >= 8 MiB; it cannot be accepted for this 8 MB flash device."
    exit 1
  fi
done

echo "Image size guard passed. Verify image-specific partition limits and checksum before any flash."
