# Install local gha cache server

# move compose file in place

mkdir -p /srv
mv /scripts/github-actions-cache-server /srv/github-actions-cache-server
cd /srv/github-actions-cache-server

# Launch once so 1. the image is downloaded and 2. it gets re-started on worker boot
docker compose up -d

# tweak runner config
cat env >> $GITHUB_ENV

