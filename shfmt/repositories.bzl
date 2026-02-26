def _shfmt_http_impl(repository_ctx):
    sha256 = repository_ctx.attr.sha256
    url = repository_ctx.attr.url

    repository_ctx.template(
        "BUILD.bazel",
        Label("shfmt.BUILD.bazel.tpl"),
        substitutions = {
            "%{rules}": repr(str(Label("rules.bzl"))),
            "%{sh_binary_rules}": repr(str(Label("@rules_shell//shell:sh_binary.bzl"))),
        },
    )

    repository_ctx.download(
        executable = True,
        output = "shfmt",
        sha256 = sha256,
        url = url,
    )

    return repository_ctx.repo_metadata(
        reproducible = True,
    )

shfmt_http = repository_rule(
    implementation = _shfmt_http_impl,
    attrs = {
        "sha256": attr.string(mandatory = True),
        "url": attr.string(mandatory = True),
    },
)
