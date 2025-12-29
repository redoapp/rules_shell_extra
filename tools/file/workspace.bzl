load("@bazel_util//file:workspace.bzl", "files")

def file_repositories():
    files(
        name = "files",
        build = "//tools/file:files.bazel",
        ignores = [
            ".git",
        ],
        root_file = "//:WORKSPACE.bazel",
    )
