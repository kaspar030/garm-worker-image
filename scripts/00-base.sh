echo "Updating system..."
apt-get -y update && apt-get -y dist-upgrade
apt-get -y install --no-install-recommends \
		curl clang ninja-build python3-requests tar jq zstd \
		docker-compose-v2 docker.io docker-buildx zfsutils btrfs-progs cgroupfs-mount
