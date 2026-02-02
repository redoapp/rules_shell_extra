def _shfmt_http_impl(repository_ctx):
    sha256 = repository_ctx.attr.sha256
    url = repository_ctx.attr.url
    build = repository_ctx.attr._build
    rules = repository_ctx.attr._rules
    sh_binary_rules = repository_ctx.attr._sh_binary_rules

    repository_ctx.template(
        "BUILD.bazel",
        build,
        substitutions = {
            '"%{rules}"': repr(str(rules)),
            '"%{sh_binary_rules}"': repr(str(sh_binary_rules)),
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
        "_build": attr.label(default = "shfmt.BUILD.bazel"),
        "_rules": attr.label(default = "rules.bzl"),
        "_sh_binary_rules": attr.label(default = "@rules_shell//shell:sh_binary.bzl"),
    },
)
