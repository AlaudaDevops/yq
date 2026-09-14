#!/bin/sh
set -ex

# Keep tooling installation deterministic and aligned with the active Go toolchain.
# This avoids prebuilt golangci-lint binaries being built by an older Go version.
GOLANGCI_LINT_VERSION=v2.11.2
GOSEC_VERSION=v2.29.0

go mod download golang.org/x/tools@latest
go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@${GOLANGCI_LINT_VERSION}
# Build gosec from source with the active toolchain (prebuilt binaries lag).
go install github.com/securego/gosec/v2/cmd/gosec@${GOSEC_VERSION}  # cspell:disable-line
