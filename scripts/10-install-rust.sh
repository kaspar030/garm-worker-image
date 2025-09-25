#!/bin/bash -e

# based on https://github.com/actions/runner-images/blob/main/images/ubuntu/scripts/build/install-rust.sh

source helpers/etc-environment.sh

export RUSTUP_HOME=/etc/skel/.rustup
export CARGO_HOME=/etc/skel/.cargo

curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable --profile=minimal

# Initialize environment variables
source $CARGO_HOME/env

# Ensure they get reinitialized for the github runner user
# TODO: figure out how to use '$HOME'
prepend_etc_environment_path '/home/runner/.cargo/bin'

# Install common tools
rustup component add rustfmt clippy

# Install nightly toolchain
rustup toolchain install ${RUST_NIGHTLY_TOOLCHAIN} -c ${RUST_COMPONENTS}  -t ${RUST_TARGETS}
# Install stable toolchain
rustup toolchain install ${RUST_STABLE_TOOLCHAIN} -c ${RUST_COMPONENTS} -t ${RUST_TARGETS}

# Cleanup Cargo cache
rm -rf ${CARGO_HOME}/registry/*
