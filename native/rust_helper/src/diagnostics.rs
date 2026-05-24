use crate::{helper_ok, HelperResponse};

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct HelperDiagnosticsResult {
    pub helper_ready: bool,
    pub authority_path: bool,
}

pub fn helper_diagnostics() -> HelperResponse<HelperDiagnosticsResult> {
    helper_ok(
        "diagnostics.helper",
        HelperDiagnosticsResult {
            helper_ready: true,
            authority_path: false,
        },
        vec![],
    )
}
