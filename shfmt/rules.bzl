load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_util//generate:providers.bzl", "FormatterInfo")

def _shfmt_format(ctx, src, out, bin):
    args = ctx.actions.args()
    args.add(bin.executable)
    args.add(src)
    args.add(out)
    args.add(paths.dirname(out.path))
    ctx.actions.run_shell(
        arguments = [args],
        command = 'mkdir -p "$4" && "$1" -ci -i 4 "$2" > "$3"',
        inputs = [src],
        mnemonic = "ShfmtFormat",
        outputs = [out],
        progress_message = "Formatting %{input}",
        tools = [bin],
    )

def _shfmt_format_impl(ctx):
    shfmt = ctx.toolchains[":toolchain_type"]

    def format(ctx, path, src, out):
        _shfmt_format(ctx, src, out, shfmt.bin)

    format_info = FormatterInfo(fn = format)

    return [format_info]

shfmt_format = rule(
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
