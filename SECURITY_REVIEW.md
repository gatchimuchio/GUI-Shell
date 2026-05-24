# Security Review

Current status: boundary hardening skeleton.

Established boundaries:

- Shell Core owns policy evaluation.
- Adapter metadata is untrusted.
- Memory, cache, previous state, and local UI state cannot grant authority.
- Rust helper is diagnostic/framing/hash/signature-boundary only.
- Flutter apps are operator surfaces only.
- Installer state cannot grant authority or silently approve permissions.
- Mobile companion cannot become independent authority.

Remaining review before release:

- persistent audit storage
- signed update verification implementation
- runtime adapter live failure handling
- installer packaging behavior
- mobile pairing cryptographic proof
- license and dependency audit
