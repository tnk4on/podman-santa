# Containerfile for tnk4on/podman-santa
FROM registry.access.redhat.com/ubi9/ubi as build
ENV ARCH=${ARCH:-arm64}

RUN dnf install gcc git libpng-devel libjpeg-turbo-devel automake autoconf-archive -y
RUN git clone https://github.com/Talinx/jp2a.git
RUN cd jp2a \
&& autoreconf -vi \
&& ./configure --host=${ARCH} && make

FROM registry.access.redhat.com/ubi9/ubi-minimal
LABEL maintainer="Shion Tanaka / Twitter(@tnk4on)"
WORKDIR /app
RUN microdnf install libjpeg-turbo-devel libpng-devel -y \
&& microdnf clean all

COPY santaseal.png /app/santaseal.png
COPY --from=build /jp2a/src/jp2a /usr/local/bin/

ENTRYPOINT ["jp2a","--colors","--fill","--color-depth=24","--chars='podman'","/app/santaseal.png"]
CMD ["--width=120"]