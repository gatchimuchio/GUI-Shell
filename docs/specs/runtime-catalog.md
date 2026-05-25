# Runtime Catalog

The Runtime Catalog is manifest-controlled. GUI-Shell must not hard-code runtime behavior into Shell Core.

Catalog entries are composed from:

- RuntimeManifest
- AdapterManifest
- PlatformProfile
- TrustProfile
- CapabilityProfile
- PermissionProfile
- RecoveryProfile

Manifests are descriptive inputs. They cannot grant authority by themselves.

Minimum RuntimeManifest fields:

- `runtime_id`
- `display_name`
- `runtime_type`
- `supported_platforms`
- `required_tools`
- `required_ports`
- `storage_paths`
- `network_policy`
- `capabilities`
- `permissions`
- `audit_profile`
- `recovery_profile`
- `trust_profile`
- `signed_manifest`
