#!/usr/bin/env bash
set -euo pipefail
root="${1:-openwrt}"
cd "$root"

echo "Checking ath79/generic target..."
test -f target/linux/ath79/Makefile || {
  echo "::error::ath79 target absent in this source tree"; exit 1;
}
grep -q 'generic' target/linux/ath79/Makefile || {
  echo "::error::ath79 generic subtarget not found"; exit 1;
}

echo "Checking device DTS..."
dts="$(find target/linux/ath79 -type f -iname '*wr841hp*v3*.dts' -print -quit)"
if [ -z "$dts" ]; then
  echo "::error::No TL-WR841HP v3 DTS found. Backport DTS and its Makefile inclusion."
  exit 1
fi
echo "Found DTS: $dts"
grep -qi 'tl-wr841hp-v3' "$dts" || {
  echo "::error::DTS does not declare expected model/compatible"; exit 1;
}
grep -qi 'qca9533' "$dts" || {
  echo "::error::DTS does not reference QCA9533"; exit 1;
}

echo "Checking image recipe and hardware ID..."
if ! grep -RqsE 'tl-wr841hp-v3|TL-WR841HP' target/linux/ath79/image; then
  echo "::error::No image recipe for TL-WR841HP v3 found"; exit 1
fi
if ! grep -RqsE '0x08411003|08411003' target/linux/ath79/image; then
  echo "::error::Expected TP-Link v3 hardware ID 0x08411003 not found in image recipes"
  exit 1
fi

echo "Checking package definition for opennds..."
if ! find package feeds -type f \\( -iname 'Makefile' -o -iname '*.mk' \\) -print0 2>/dev/null |
  xargs -0 grep -ilqE 'opennds|opennds' ; then
  echo "::error::opennds package definition not found in source/feeds; identify a compatible feed/commit and backport it."
  exit 1
fi

echo "Static validation passed. This does NOT prove DTS correctness, image bootability, or hardware compatibility."
