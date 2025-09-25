echo "Installing GH actions runner..." 

# Get and install the runner
mkdir -p /home/runner/actions-runner
cd /home/runner/actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
rm ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# install runner deps
./bin/installdependencies.sh

export GITHUB_ENV=/home/runner/actions-runner.env
