FROM gitlab.int.toradex.com:4567/rd/torizon-core/debian/debian-package-devel/arm64v8-debian-package-devel:bullseye

ADD . / builddir/
WORKDIR builddir

RUN apt-get update && apt-get install -y --no-install-recommends \
    patchelf \
    apt-file \
    && apt-file update

RUN mk-build-deps --install --tool 'apt-get -y -o Acquire::http::Dl-Limit=1000 -o Debug::pkgProblemResolver=yes --no-install-recommends' debian/control
RUN ./build_deb.sh

RUN rm -rf /var/lib/apt/lists/*
