const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const mod = b.addModule("zig_metal_bindings", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
    });
    addMetalWrapper(mod, b, target);

    const mod_tests = b.addTest(.{
        .root_module = mod,
    });
    const run_mod_tests = b.addRunArtifact(mod_tests);

    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_mod_tests.step);
}

fn addMetalWrapper(module: *std.Build.Module, b: *std.Build, target: std.Build.ResolvedTarget) void {
    module.addIncludePath(b.path("src"));

    if (target.result.os.tag != .macos) return;

    module.addCSourceFile(.{
        .file = b.path("src/metal_wrapper.m"),
        .language = .objective_c,
    });
    module.linkFramework("Foundation", .{});
    module.linkFramework("Metal", .{});
}
