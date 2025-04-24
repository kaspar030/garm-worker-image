#!/bin/bash -e

# based on https://github.com/actions/runner-images/blob/main/images/ubuntu/scripts/build/install-rust.sh

source helpers/etc-environment.sh

export RUSTUP_HOME=/etc/skel/.rustup
export CARGO_HOME=/etc/skel/.cargo

curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable --profile=minimal

# Initialize environment variables
source $CARGO_HOME/env

# Install common tools
rustup component add rustfmt clippy

# Cleanup Cargo cache
rm -rf ${CARGO_HOME}/registry/*

# Update /etc/environment
prepend_etc_environment_path '$HOME/.cargo/bin'
