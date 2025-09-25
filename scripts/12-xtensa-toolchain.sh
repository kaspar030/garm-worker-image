cargo install espup@${ESPUP_VERSION} --locked

RUN espup install -v ${RUST_XTENSA_TOOLCHAIN_VERSION} --targets ${RUST_XTENSA_TARGETS}
