use sha2::{Digest, Sha256};

pub fn sha256_tagged(input: &[u8]) -> String {
    let digest = Sha256::digest(input);
    format!("sha256:{}", hex::encode(digest))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn sha256_tagged_has_expected_prefix_and_length() {
        let value = sha256_tagged(b"gui-shell");
        assert!(value.starts_with("sha256:"));
        assert_eq!(value.len(), 71);
    }
}
