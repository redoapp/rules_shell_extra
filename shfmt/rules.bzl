load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_util//generate:providers.bzl", "FormatterInfo")

def _shfmt_format(ctx, format_default, src, out, bin, options):
    args = ctx.actions.args()
    args.add(bin.executable)
    args.add(src)
    args.add(out)
    args.add(paths.dirname(out.path))
    args.add_all(options)
    ctx.actions.run(
        arguments = [args],
        executable = format_default.files_to_run.executable,
        inputs = [src],
        mnemonic = "ShfmtFormat",
        outputs = [out],
        progress_message = "Formatting %{input}",
        tools = [bin, format_default.files_to_run],
    )

def _shfmt_format_impl(ctx):
    format_default = ctx.attr._format[DefaultInfo]
    shfmt = ctx.toolchains[":toolchain_type"]
    options = ctx.attr.options

    def format(ctx, path, src, out):
        _shfmt_format(ctx, format_default, src, out, shfmt.bin, options)

    format_info = FormatterInfo(fn = format)

    return [format_info]

shfmt_format = rule(
    attrs = {
        "options": attr.string_list(),
        "_format": attr.label(
            default = "//shfmt:format",
            executable = True,
            cfg = "exec",
        ),
    },
    implementation = _shfmt_format_impl,
    toolchains = [":toolchain_type"],
)

def _shfmt_toolchain_impl(ctx):
    bin_default = ctx.attr.bin[DefaultInfo]

    toolchain_info = platform_common.ToolchainInfo(
        bin = bin_default.files_to_run,
    )

    return [toolchain_info]

shfmt_toolchain = rule(
    implementation = _shfmt_toolchain_impl,
    attrs = {
        "bin": attr.label(
            default = "//terraform/bin:terraform",
        ),
    },
)
