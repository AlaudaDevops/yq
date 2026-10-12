#!/bin/sh
set -ex

# Keep tooling installation deterministic and aligned with the active Go toolchain.
# This avoids prebuilt golangci-lint binaries being built by an older Go version.
# v2.11.x panics while analysing Go 1.27's internal/poll package
# ("unexpected expr: *ast.KeyValueExpr"); v2.14.0 handles Go 1.27.
GOLANGCI_LINT_VERSION=v2.14.0
GOSEC_VERSION=v2.29.0
# gosec v2.29.0 pins golang.org/x/tools v0.49.0, which cannot decode Go 1.27
# export data ("export data version 5 is greater than maximum supported
# version"), so every package fails to type-check. Build it against a newer
# x/tools until a gosec release catches up.
GOSEC_X_TOOLS_VERSION=v0.52.0

go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}
# Build gosec from source with the active toolchain (prebuilt binaries lag).
GOSEC_BUILD_DIR="$(mktemp -d)"
(
  cd "${GOSEC_BUILD_DIR}"
  go mod init devtools-build
  go get github.com/securego/gosec/v2/cmd/gosec@${GOSEC_VERSION} golang.org/x/tools@${GOSEC_X_TOOLS_VERSION}  # cspell:disable-line
  go install github.com/securego/gosec/v2/cmd/gosec  # cspell:disable-line
)
rm -rf "${GOSEC_BUILD_DIR}"
