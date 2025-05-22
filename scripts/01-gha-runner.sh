echo "Installing GH actions runner..." 

GHAR_VER=2.324.0

# Get and install the runner
mkdir -p /opt/cache/actions-runner/latest
cd /opt/cache/actions-runner/latest
curl -O -L https://github.com/actions/runner/releases/download/v${GHAR_VER}/actions-runner-linux-x64-${GHAR_VER}.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-${GHAR_VER}.tar.gz
rm ./actions-runner-linux-x64-${GHAR_VER}.tar.gz

# horrible hack needed by gha-cache-server so the runner doesn't overwrite ACTIONS_RESULTS_URL.
sed -i 's/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x55\x00\x52\x00\x4C\x00/\x41\x00\x43\x00\x54\x00\x49\x00\x4F\x00\x4E\x00\x53\x00\x5F\x00\x52\x00\x45\x00\x53\x00\x55\x00\x4C\x00\x54\x00\x53\x00\x5F\x00\x4F\x00\x52\x00\x4C\x00/g' bin/Runner.Worker.dll

# install runner deps
./bin/installdependencies.sh

export GITHUB_ENV=/opt/cache/actions-runner/latest/.env
