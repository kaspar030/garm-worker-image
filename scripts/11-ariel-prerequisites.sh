echo "Installing Ariel OS build deps"
export DEBIAN_FRONTEND=noninteractive
apt-get -y install --no-install-recommends \
	ninja-build gcc-arm-none-eabi gcc-riscv64-unknown-elf

cargo install laze@${LAZE_VERSION} --locked