export BASE_IMAGE="images:ubuntu/24.04/cloud"
export TARGET_IMAGE="ubuntu-24-04-gh"

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

# Copy over scripts
incus file push -r scripts ${TARGET_IMAGE}-temp/

# Enter bash inside the container
cat <<EOF | incus exec ${TARGET_IMAGE}-temp -- bash
set -x
set -e

cd /scripts

for i in *.sh; do
    # ensure we're still here
    cd /scripts
    # source shell snippets
    . \${i}
done

rm -Rf /scripts

# Exit the container
exit

EOF

# Stop the instance and publish it as a new image
incus stop ${TARGET_IMAGE}-temp
incus publish ${TARGET_IMAGE}-temp --alias $TARGET_IMAGE --reuse

# Update garm to use the new image
# garm-cli pool update $POOL_ID --image=${TARGET_IMAGE}
