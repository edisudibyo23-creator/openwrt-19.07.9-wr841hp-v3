# Backport patches go here

This folder intentionally contains no unverified device patch.

Add audited `*.patch` files in dependency order. A complete backport must:
- add/port the TL-WR841HP v3 DTS and required DTS Makefile inclusion;
- add the device image definition with correct TP-Link image wrapper and hardware ID;
- register the device profile in the 19.07.9 target/image build machinery;
- resolve any kernel DTS/include differences between 19.07.9 and the upstream support commit;
- provide a compatible `opennds` package definition and dependencies if absent from the 19.07.9 feeds.

The workflow fails if this folder is empty or required markers are absent. Do not bypass validation by changing checks to unconditional success.
