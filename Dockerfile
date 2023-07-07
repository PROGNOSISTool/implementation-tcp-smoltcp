FROM rust:slim-buster as build
RUN apt-get update && apt-get install -y curl wget build-essential net-tools iptables iproute2 git

COPY . /src
WORKDIR /src

RUN cargo build --example server

FROM debian:buster as runtime

COPY --from=build \
    /src/target/debug/examples/server \
    /usr/local/bin/

COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod ug+x ./entrypoint.sh

RUN apt-get update && apt-get install -y iptables iproute2 bridge-utils net-tools kmod dhcpcd5

CMD ["./entrypoint.sh"]