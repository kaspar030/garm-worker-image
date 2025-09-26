echo "Installing GH actions runner..." 

# Get and install the runner
mkdir -p /opt/cache/actions-runner/latest
cd /opt/cache/actions-runner/latest
curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install runner deps
./bin/installdependencies.sh

export GITHUB_ENV=/opt/cache/actions-runner/latest/.env