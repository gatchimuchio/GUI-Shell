use sha2::{Digest, Sha256};

use crate::{helper_ok, HelperResponse};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AuditHashResult {
    pub hash: String,
}

pub fn sha256_tagged(input: &[u8]) -> String {
    let digest = Sha256::digest(input);
    format!("sha256:{}", hex::encode(digest))
}

pub fn audit_hash(input: &[u8]) -> HelperResponse<AuditHashResult> {
    helper_ok(
        "audit_hash.sha256",
        AuditHashResult {
            hash: sha256_tagged(input),
        },
        vec![],
    )
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn audit_hash_is_deterministic() {
        let first = audit_hash(br#"{"a":1}"#);
        let second = audit_hash(br#"{"a":1}"#);
        assert!(first.ok);
        assert_eq!(first.result, second.result);
        assert_eq!(first.result.unwrap().hash.len(), 71);
    }
}
