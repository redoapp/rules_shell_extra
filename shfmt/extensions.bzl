load("@bazel_skylib//lib:versions.bzl", "versions")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")
load(":repositories.bzl", "shfmt_http")

_shfmt_toolchain = tag_class(
    attrs = {
        "sha256s": attr.string_dict(),
        "version": attr.string(mandatory = True),
    },
)

_FACTS_KEY = "_"

def _shfmt_impl(module_ctx):
    version = None
    for module in module_ctx.modules:
        for toolchain in module.tags.toolchain:
            if version == None or versions.is_at_least(version, toolchain.version):
                version = toolchain.version
    version = version or "3.12.0"

    facts = module_ctx.facts.get(_FACTS_KEY)

    sha256s = module_ctx.facts.get("sha256s")
    if sha256s == None:
        sha256s = {}
        module_ctx.download(
            output = "release.json",
            url = "https://api.github.com/repos/mvdan/sh/releases/tags/v%s" % version,
        )
        release = json.decode(module_ctx.read("release.json"))
        for asset in release["assets"]:
            if not asset["name"].startswith("shfmt_"):
                continue
            sha256s[asset["name"]] = asset["digest"].replace("sha256:", "")

    for platform_name, platform in _platforms.items():
        shfmt_http(
            name = "shfmt_%s" % platform_name.replace("-", "_"),
            sha256 = sha256s["shfmt_v%s_%s" % (version, platform.path)],
            url = "https://github.com/mvdan/sh/releases/download/v%s/shfmt_v%s_%s" % (version, version, platform.path),
        )

    return module_ctx.extension_metadata(
        facts = {_FACTS_KEY: {"sha256s": sha256s}},
        reproducible = True,
    )

shfmt = module_extension(
    implementation = _shfmt_impl,
    tag_classes = {"toolchain": _shfmt_toolchain},
)

_platforms = {
    "darwin-amd64": struct(path = "darwin_amd64"),
    "darwin-arm64": struct(path = "darwin_arm64"),
    "linux-386": struct(path = "linux_386"),
    "linux-amd64": struct(path = "linux_amd64"),
    "linux-arm": struct(path = "linux_arm"),
    "linux-arm64": struct(path = "linux_arm64"),
    "windows-386": struct(path = "windows_386.exe"),
    "windows-amd64": struct(path = "windows_amd64.exe"),
}
