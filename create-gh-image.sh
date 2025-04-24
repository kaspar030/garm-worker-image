export BASE_IMAGE="images:ubuntu/24.04/cloud"
export TARGET_IMAGE="ubuntu-24-04-gh"
export POOL_ID=ce38dce0-d34c-4870-bae4-20f24933a3ef

set -x
set -e

function cleanup()
{
    # Delete the temporary instance
    incus delete ${TARGET_IMAGE}-temp --force
}

trap cleanup EXIT 

# Create a temporary instance from your base image
incus launch $BASE_IMAGE ${TARGET_IMAGE}-temp

# Enter bash inside the container
cat <<EOF | sed s/GHAR_VER/2.323.0/g | incus exec ${TARGET_IMAGE}-temp -- bash
set -x

echo "Updating system..."
apt-get -y update && apt-get -y dist-upgrade
apt-get -y install --no-install-recommends \
		curl clang ninja-build python3-requests rustup tar jq zstd \
		docker-compose-v2 docker.io docker-buildx zfsutils btrfs-progs cgroupfs-mount

echo "Installing GH actions runner..." 
# Get and install the runner
mkdir -p /opt/cache/actions-runner/latest
cd /opt/cache/actions-runner/latest
curl -O -L https://github.com/actions/runner/releases/download/vGHAR_VER/actions-runner-linux-x64-GHAR_VER.tar.gz
# Extract the installer
tar xzf ./actions-runner-linux-x64-GHAR_VER.tar.gz
rm ./actions-runner-linux-x64-GHAR_VER.tar.gz

# horrible hack needed by gha-cache-server so the runner doesn't overwrite ACTIONS_RESULTS_URL.

sed -i 's/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x55\x00\x52\x00\x4C\x00/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x4F\x00\x52\x00\x4C\x00/g' bin/Runner.Worker.dll

# install runner deps
./bin/installdependencies.sh

# Exit the container
exit

EOF

incus file push -r github-actions-cache-server ${TARGET_IMAGE}-temp/srv
incus file push env ${TARGET_IMAGE}-temp/opt/cache/actions-runner/latest/.env

incus exec ${TARGET_IMAGE}-temp --cwd /srv/github-actions-cache-server -- docker compose up -d

# Stop the instance and publish it as a new image
incus stop ${TARGET_IMAGE}-temp
incus publish ${TARGET_IMAGE}-temp --alias $TARGET_IMAGE --reuse

# Update garm to use the new image
garm-cli pool update $POOL_ID --image=${TARGET_IMAGE}
