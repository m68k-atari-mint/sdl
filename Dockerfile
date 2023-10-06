ARG BUILD_DIR=/build

FROM mikrosk/m68k-atari-mint-gemlib:master as gemlib
FROM mikrosk/m68k-atari-mint-ldg:master as ldg

FROM mikrosk/m68k-atari-mint-base:master as base

WORKDIR /src
COPY --from=gemlib ${SYSROOT_DIR} ${SYSROOT_DIR}/
COPY --from=ldg ${SYSROOT_DIR} ${SYSROOT_DIR}/

# renew the arguments
ARG BUILD_DIR

ENV SDL_BRANCH		    main
ENV SDL_URL             https://github.com/mikrosk/SDL-1.2/archive/refs/heads/${SDL_BRANCH}.tar.gz
ENV SDL_FOLDER          SDL-1.2-${SDL_BRANCH}
RUN wget -q -O - ${SDL_URL} | tar xzf -

RUN cd ${SDL_FOLDER} \
    && ../build.sh ${BUILD_DIR}

FROM scratch

# renew the arguments
ARG BUILD_DIR

COPY --from=base ${BUILD_DIR} /
