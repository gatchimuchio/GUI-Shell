use crate::{helper_error, helper_ok, HelperResponse};

const MAX_FRAME_BYTES: usize = 1024 * 1024;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct IpcFrame {
    pub operation: String,
    pub payload: Vec<u8>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct IpcFrameResult {
    pub operation: String,
    pub byte_len: usize,
}

pub fn frame_message(frame: &IpcFrame) -> HelperResponse<IpcFrameResult> {
    if frame.operation.is_empty() {
        return helper_error(
            "ipc.frame",
            "ipc_operation_required",
            "ipc operation is required",
            true,
            vec![],
        );
    }
    if frame.payload.len() > MAX_FRAME_BYTES {
        return helper_error(
            "ipc.frame",
            "ipc_frame_too_large",
            "ipc frame exceeds maximum size",
            true,
            vec![],
        );
    }

    helper_ok(
        "ipc.frame",
        IpcFrameResult {
            operation: frame.operation.clone(),
            byte_len: frame.payload.len(),
        },
        vec![],
    )
}
