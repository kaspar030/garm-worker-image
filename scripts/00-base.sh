echo "Updating system..."
export DEBIAN_FRONTEND=noninteractive
apt-get -y update && apt-get -y dist-upgrade
apt-get -y install --no-install-recommends \
		curl python3-requests tar jq zstd bzip2 \
		clang ninja-build make gcc \
		docker-compose-v2 docker.io docker-buildx zfsutils btrfs-progs cgroupfs-mount \
		git git-lfs
