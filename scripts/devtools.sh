#!/bin/sh
set -ex

# Keep tooling installation deterministic and aligned with the active Go toolchain.
# This avoids prebuilt golangci-lint binaries being built by an older Go version.
GOLANGCI_LINT_VERSION=v2.11.2
GOSEC_VERSION=v2.22.5

go mod download golang.org/x/tools@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}
curl -sSfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s ${GOSEC_VERSION}
