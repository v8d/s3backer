FROM alpine:latest

RUN apk add --force-refresh --no-cache bash gcc automake autoconf musl-dev libcurl curl-dev fuse-dev expat-dev libssl1.0 make
RUN wget --directory-prefix=/usr/include/sys/ https://raw.githubusercontent.com/MatthewVance/dnscrypt-server-docker/master/queue.h
RUN wget https://s3.amazonaws.com/archie-public/s3backer/s3backer-1.5.0.tar.gz
RUN tar -xzvf s3backer-1.5.0.tar.gz
   
WORKDIR /s3backer-1.5.0

RUN ./configure && make && make install

# STAGE 2 --------

FROM alpine:latest

COPY --from=0 /usr/lib/libfuse.so.2 /usr/lib/
COPY --from=0 /usr/lib/libexpat.so.1 /usr/lib/
COPY --from=0 /usr/lib/libcurl.so.4 /usr/lib/
COPY --from=0 /usr/lib/libnghttp2.so.14 /usr/lib/
COPY --from=0 /usr/lib/libssh2.so.1 /usr/lib/

#RUN apk add --force-refresh --no-cache fuse

COPY --from=0 /s3backer-1.5.0/s3backer /usr/local/bin/
