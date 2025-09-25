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

# Install current ariel os stable rust
rustup toolchain install 1.85.1 --target riscv32imc-unknown-none-elf --target riscv32imac-unknown-none-elf --target thumbv6m-none-eabi --target thumbv7m-none-eabi --target thumbv7em-none-eabi --target thumbv7em-none-eabihf --target thumbv8m.main-none-eabi --target thumbv8m.main-none-eabihf --component rust-src --component rustfmt --profile minimal --no-self-update

# Cleanup Cargo cache
rm -rf ${CARGO_HOME}/registry/*
