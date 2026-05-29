#ifndef METAL_WRAPPER_H
#define METAL_WRAPPER_H

#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void* MTLDeviceRef;
typedef void* MTLCommandQueueRef;
typedef void* MTLCommandBufferRef;
typedef void* MTLLibraryRef;
typedef void* MTLFunctionRef;
typedef void* MTLComputePipelineStateRef;
typedef void* MTLBufferRef;
typedef void* MTLComputeCommandEncoderRef;

MTLDeviceRef metal_create_system_default_device(void);
const char* metal_device_name(MTLDeviceRef device);
void metal_device_release(MTLDeviceRef device);

MTLCommandQueueRef metal_new_command_queue(MTLDeviceRef device);
void metal_command_queue_release(MTLCommandQueueRef queue);

MTLCommandBufferRef metal_command_queue_command_buffer(MTLCommandQueueRef queue);
void metal_command_buffer_commit(MTLCommandBufferRef buffer);
void metal_command_buffer_wait_until_completed(MTLCommandBufferRef buffer);
void metal_command_buffer_release(MTLCommandBufferRef buffer);

MTLLibraryRef metal_new_library_with_source(
    MTLDeviceRef device,
    const char* source,
    char** error_out
);
MTLFunctionRef metal_library_new_function(MTLLibraryRef library, const char* name);
void metal_library_release(MTLLibraryRef library);
void metal_function_release(MTLFunctionRef function);

MTLComputePipelineStateRef metal_new_compute_pipeline_state(
    MTLDeviceRef device,
    MTLFunctionRef function,
    char** error_out
);
void metal_pipeline_state_release(MTLComputePipelineStateRef pipeline);

MTLBufferRef metal_new_buffer_with_bytes(
    MTLDeviceRef device,
    const void* bytes,
    uint64_t length,
    uint64_t options
);
MTLBufferRef metal_new_buffer_with_length(
    MTLDeviceRef device,
    uint64_t length,
    uint64_t options
);
void* metal_buffer_contents(MTLBufferRef buffer);
uint64_t metal_buffer_length(MTLBufferRef buffer);
void metal_buffer_release(MTLBufferRef buffer);

MTLComputeCommandEncoderRef metal_command_buffer_compute_command_encoder(
    MTLCommandBufferRef buffer
);
void metal_compute_encoder_set_pipeline_state(
    MTLComputeCommandEncoderRef encoder,
    MTLComputePipelineStateRef pipeline
);
void metal_compute_encoder_set_buffer(
    MTLComputeCommandEncoderRef encoder,
    MTLBufferRef buffer,
    uint64_t offset,
    uint64_t index
);
void metal_compute_encoder_dispatch_threads(
    MTLComputeCommandEncoderRef encoder,
    uint64_t threads_x,
    uint64_t threads_y,
    uint64_t threads_z,
    uint64_t threadgroup_x,
    uint64_t threadgroup_y,
    uint64_t threadgroup_z
);
void metal_compute_encoder_end_encoding(MTLComputeCommandEncoderRef encoder);
void metal_compute_encoder_release(MTLComputeCommandEncoderRef encoder);

#define METAL_RESOURCE_STORAGE_MODE_SHARED 0
#define METAL_RESOURCE_CPU_CACHE_MODE_DEFAULT_CACHE 0

#ifdef __cplusplus
}
#endif

#endif
