echo "Installing GH actions runner..."

GHAR_VER=2.337.0

# Download the runner package
mkdir -p /home/runner/actions-runner
cd /home/runner/actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v${GHAR_VER}/actions-runner-linux-x64-${GHAR_VER}.tar.gz

# Extract the installer
tar xzf ./actions-runner-linux-x64-${GHAR_VER}.tar.gz
rm ./actions-runner-linux-x64-${GHAR_VER}.tar.gz

# install runner deps
./bin/installdependencies.sh

# Remove the directory so GARM installs an up-to-date version
rm -r /home/runner/actions-runner
