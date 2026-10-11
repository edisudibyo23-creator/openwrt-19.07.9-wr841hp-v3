#!/usr/bin/env bash
set -euo pipefail
cfg="${1:-.config}"

grep -qx 'CONFIG_TARGET_ath79=y' "$cfg" || {
  echo "::error::CONFIG_TARGET_ath79 not enabled"; exit 1;
}
grep -qx 'CONFIG_TARGET_ath79_generic=y' "$cfg" || {
  echo "::error::CONFIG_TARGET_ath79_generic not enabled"; exit 1;
}
grep -qx 'CONFIG_PACKAGE_luci=y' "$cfg" || {
  echo "::error::LuCI not selected"; exit 1;
}
grep -qx 'CONFIG_PACKAGE_opennds=y' "$cfg" || {
  echo "::error::opennds not selected; check package availability and dependencies"; exit 1;
}

if ! grep -q 'CONFIG_TARGET_ath79_generic_DEVICE_.*wr841hp.*v3=y' "$cfg"; then
  echo "::error::Device profile is not selected in .config. Backport/register profile first."
  exit 1
fi
echo "Config checks passed."
