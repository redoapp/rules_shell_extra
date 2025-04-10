load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def shfmt_repositories():
    http_file(
        name = "shfmt_darwin_amd64",
        downloaded_file_path = "shfmt",
        executable = True,
        sha256 = "810a76cb7c78351e021c8025f344b12149d8426ce51609a179af68109ed5698e",
        url = "https://github.com/mvdan/sh/releases/download/v3.11.0/shfmt_v3.11.0_darwin_amd64",
    )

    http_file(
        name = "shfmt_darwin_arm64",
        downloaded_file_path = "shfmt",
        executable = True,
        sha256 = "af206d234dff5d05d9ac355529b2b33a7a78e13fab9b59db777746aab3e72530",
        url = "https://github.com/mvdan/sh/releases/download/v3.11.0/shfmt_v3.11.0_darwin_arm64",
    )

    http_file(
        name = "shfmt_linux_amd64",
        downloaded_file_path = "shfmt",
        executable = True,
        sha256 = "1904ec6bac715c1d05cd7f6612eec8f67a625c3749cb327e5bfb4127d09035ff",
        url = "https://github.com/mvdan/sh/releases/download/v3.11.0/shfmt_v3.11.0_linux_amd64",
    )

    http_file(
        name = "shfmt_linux_arm64",
        downloaded_file_path = "shfmt",
        executable = True,
        sha256 = "b3976121710fd4b12bf641b0a7fb2686da598fb0da9f148c641b61b54cfa3407",
        url = "https://github.com/mvdan/sh/releases/download/v3.11.0/shfmt_v3.11.0_linux_arm64",
    )

def shfmt_toolchains():
    native.register_toolchains(
        str(Label(":linux_arm64_toolchain")),
        str(Label(":linux_x86_64_toolchain")),
        str(Label(":macos_arm64_toolchain")),
        str(Label(":macos_x86_64_toolchain")),
    )
