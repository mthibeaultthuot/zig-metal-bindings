#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include "metal_wrapper.h"
#include <string.h>

MTLDeviceRef metal_create_system_default_device(void) {
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    return (__bridge_retained MTLDeviceRef)device;
}

const char* metal_device_name(MTLDeviceRef device) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    NSString* name = [mtlDevice name];
    return [name UTF8String];
}

void metal_device_release(MTLDeviceRef device) {
    if (device) {
        CFRelease(device);
    }
}

MTLCommandQueueRef metal_new_command_queue(MTLDeviceRef device) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    id<MTLCommandQueue> queue = [mtlDevice newCommandQueue];
    return (__bridge_retained MTLCommandQueueRef)queue;
}

void metal_command_queue_release(MTLCommandQueueRef queue) {
    if (queue) {
        CFRelease(queue);
    }
}

MTLCommandBufferRef metal_command_queue_command_buffer(MTLCommandQueueRef queue) {
    id<MTLCommandQueue> mtlQueue = (__bridge id<MTLCommandQueue>)queue;
    id<MTLCommandBuffer> buffer = [mtlQueue commandBuffer];
    return (__bridge_retained MTLCommandBufferRef)buffer;
}

void metal_command_buffer_commit(MTLCommandBufferRef buffer) {
    id<MTLCommandBuffer> mtlBuffer = (__bridge id<MTLCommandBuffer>)buffer;
    [mtlBuffer commit];
}

void metal_command_buffer_wait_until_completed(MTLCommandBufferRef buffer) {
    id<MTLCommandBuffer> mtlBuffer = (__bridge id<MTLCommandBuffer>)buffer;
    [mtlBuffer waitUntilCompleted];
}

void metal_command_buffer_release(MTLCommandBufferRef buffer) {
    if (buffer) {
        CFRelease(buffer);
    }
}

MTLLibraryRef metal_new_library_with_source(
    MTLDeviceRef device,
    const char* source,
    char** error_out
) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    NSString* sourceString = [NSString stringWithUTF8String:source];

    NSError* error = nil;
    id<MTLLibrary> library = [mtlDevice newLibraryWithSource:sourceString
                                                     options:nil
                                                       error:&error];

    if (error && error_out) {
        NSString* errorString = [error localizedDescription];
        *error_out = strdup([errorString UTF8String]);
    }

    if (!library) {
        return NULL;
    }

    return (__bridge_retained MTLLibraryRef)library;
}

MTLFunctionRef metal_library_new_function(MTLLibraryRef library, const char* name) {
    id<MTLLibrary> mtlLibrary = (__bridge id<MTLLibrary>)library;
    NSString* nameString = [NSString stringWithUTF8String:name];
    id<MTLFunction> function = [mtlLibrary newFunctionWithName:nameString];

    if (!function) {
        return NULL;
    }

    return (__bridge_retained MTLFunctionRef)function;
}

void metal_library_release(MTLLibraryRef library) {
    if (library) {
        CFRelease(library);
    }
}

void metal_function_release(MTLFunctionRef function) {
    if (function) {
        CFRelease(function);
    }
}

MTLComputePipelineStateRef metal_new_compute_pipeline_state(
    MTLDeviceRef device,
    MTLFunctionRef function,
    char** error_out
) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    id<MTLFunction> mtlFunction = (__bridge id<MTLFunction>)function;

    NSError* error = nil;
    id<MTLComputePipelineState> pipeline =
        [mtlDevice newComputePipelineStateWithFunction:mtlFunction error:&error];

    if (error && error_out) {
        NSString* errorString = [error localizedDescription];
        *error_out = strdup([errorString UTF8String]);
    }

    if (!pipeline) {
        return NULL;
    }

    return (__bridge_retained MTLComputePipelineStateRef)pipeline;
}

void metal_pipeline_state_release(MTLComputePipelineStateRef pipeline) {
    if (pipeline) {
        CFRelease(pipeline);
    }
}

MTLBufferRef metal_new_buffer_with_bytes(
    MTLDeviceRef device,
    const void* bytes,
    uint64_t length,
    uint64_t options
) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    id<MTLBuffer> buffer = [mtlDevice newBufferWithBytes:bytes
                                                  length:length
                                                 options:options];
    if (!buffer) {
        return NULL;
    }

    return (__bridge_retained MTLBufferRef)buffer;
}

MTLBufferRef metal_new_buffer_with_length(
    MTLDeviceRef device,
    uint64_t length,
    uint64_t options
) {
    id<MTLDevice> mtlDevice = (__bridge id<MTLDevice>)device;
    id<MTLBuffer> buffer = [mtlDevice newBufferWithLength:length options:options];

    if (!buffer) {
        return NULL;
    }

    return (__bridge_retained MTLBufferRef)buffer;
}

void* metal_buffer_contents(MTLBufferRef buffer) {
    id<MTLBuffer> mtlBuffer = (__bridge id<MTLBuffer>)buffer;
    return [mtlBuffer contents];
}

uint64_t metal_buffer_length(MTLBufferRef buffer) {
    id<MTLBuffer> mtlBuffer = (__bridge id<MTLBuffer>)buffer;
    return [mtlBuffer length];
}

void metal_buffer_release(MTLBufferRef buffer) {
    if (buffer) {
        CFRelease(buffer);
    }
}

MTLComputeCommandEncoderRef metal_command_buffer_compute_command_encoder(
    MTLCommandBufferRef buffer
) {
    id<MTLCommandBuffer> mtlBuffer = (__bridge id<MTLCommandBuffer>)buffer;
    id<MTLComputeCommandEncoder> encoder = [mtlBuffer computeCommandEncoder];

    if (!encoder) {
        return NULL;
    }

    return (__bridge_retained MTLComputeCommandEncoderRef)encoder;
}

void metal_compute_encoder_set_pipeline_state(
    MTLComputeCommandEncoderRef encoder,
    MTLComputePipelineStateRef pipeline
) {
    id<MTLComputeCommandEncoder> mtlEncoder = (__bridge id<MTLComputeCommandEncoder>)encoder;
    id<MTLComputePipelineState> mtlPipeline = (__bridge id<MTLComputePipelineState>)pipeline;
    [mtlEncoder setComputePipelineState:mtlPipeline];
}

void metal_compute_encoder_set_buffer(
    MTLComputeCommandEncoderRef encoder,
    MTLBufferRef buffer,
    uint64_t offset,
    uint64_t index
) {
    id<MTLComputeCommandEncoder> mtlEncoder = (__bridge id<MTLComputeCommandEncoder>)encoder;
    id<MTLBuffer> mtlBuffer = (__bridge id<MTLBuffer>)buffer;
    [mtlEncoder setBuffer:mtlBuffer offset:offset atIndex:index];
}

void metal_compute_encoder_dispatch_threads(
    MTLComputeCommandEncoderRef encoder,
    uint64_t threads_x,
    uint64_t threads_y,
    uint64_t threads_z,
    uint64_t threadgroup_x,
    uint64_t threadgroup_y,
    uint64_t threadgroup_z
) {
    id<MTLComputeCommandEncoder> mtlEncoder = (__bridge id<MTLComputeCommandEncoder>)encoder;

    MTLSize threadsPerGrid = MTLSizeMake(threads_x, threads_y, threads_z);
    MTLSize threadsPerThreadgroup = MTLSizeMake(threadgroup_x, threadgroup_y, threadgroup_z);

    [mtlEncoder dispatchThreads:threadsPerGrid
          threadsPerThreadgroup:threadsPerThreadgroup];
}

void metal_compute_encoder_end_encoding(MTLComputeCommandEncoderRef encoder) {
    id<MTLComputeCommandEncoder> mtlEncoder = (__bridge id<MTLComputeCommandEncoder>)encoder;
    [mtlEncoder endEncoding];
}

void metal_compute_encoder_release(MTLComputeCommandEncoderRef encoder) {
    if (encoder) {
        CFRelease(encoder);
    }
}
