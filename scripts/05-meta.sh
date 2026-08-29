echo "GARM_RUNNER_IMAGE_COMMIT=\"$(git rev-parse HEAD)\"" >> ${GITHUB_ENV}
echo "GARM_RUNNER_IMAGE_BUILD_TIME=\"$(LC_TIME=en_US.UTF-8 date)\"" >> ${GITHUB_ENV}
