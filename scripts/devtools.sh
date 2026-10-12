#!/bin/sh
set -ex

# Keep tooling installation deterministic and aligned with the active Go toolchain.
# This avoids prebuilt golangci-lint binaries being built by an older Go version.
GOLANGCI_LINT_VERSION=v2.11.2
GOSEC_VERSION=v2.29.0
# golangci-lint v2.11.2 and gosec v2.29.0 pin golang.org/x/tools <= v0.49.0,
# which cannot decode Go 1.27 export data ("export data version 5 is greater
# than maximum supported version"), so every package fails to type-check.
# Build both against a newer x/tools until upstream releases catch up.
X_TOOLS_VERSION=v0.52.0

# go_install_with_x_tools <module>@<version> <package>
go_install_with_x_tools() {
  build_dir="$(mktemp -d)"
  (
    cd "${build_dir}"
    go mod init devtools-build
    go get "$1" "golang.org/x/tools@${X_TOOLS_VERSION}"
    go install "$2"
  )
  rm -rf "${build_dir}"
}

go_install_with_x_tools github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION} github.com/golangci/golangci-lint/v2/cmd/golangci-lint
# Build gosec from source with the active toolchain (prebuilt binaries lag).
go_install_with_x_tools github.com/securego/gosec/v2/cmd/gosec@${GOSEC_VERSION} github.com/securego/gosec/v2/cmd/gosec  # cspell:disable-line
