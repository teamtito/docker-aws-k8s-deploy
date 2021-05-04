# We use a hack to get static binaries as this reduces
# the final image size drastically and it is important
# to reduce deploy process duration.

ARG DOCKER_VERSION="20.10.6"
ARG ALPINE_VERSION="3.13.5"
ARG AWS_VERSION="2.2.1"

FROM docker:${DOCKER_VERSION} as static-docker-source
FROM alpine:${ALPINE_VERSION} as downloader

ARG DOCKER_COMPOSE_VERSION="1.29.1"
ARG DOCKER_COMPOSE_SHA256="8097769d32e34314125847333593c8edb0dfc4a5b350e4839bef8c2fe8d09de7"
ARG DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64"

ARG DOCKER_BUILDX_VERSION="v0.5.1"
ARG DOCKER_BUILDX_URL="https://github.com/docker/buildx/releases/download/${DOCKER_BUILDX_VERSION}/buildx-${DOCKER_BUILDX_VERSION}.linux-amd64"
ARG DOCKER_BUILDX_SHA256="5f1dda3ae598e82c3186c2766506921e6f9f51c93b5ba43f7b42b659db4aa48d"

ARG KUBECTL_VERSION="v1.21.0"
ARG KUBECTL_SHA256="9f74f2fa7ee32ad07e17211725992248470310ca1988214518806b39b1dad9f0"
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

ARG HELM_VERSION="v3.5.4"
ARG HELM_ARCHIVE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_SHA256="a8ddb4e30435b5fd45308ecce5eaad676d64a5de9c89660b56face3fe990b318"
ARG HELM_URL="https://get.helm.sh/${HELM_ARCHIVE}"

RUN apk add --update ca-certificates \
    && apk add --update curl

RUN curl -L "${DOCKER_COMPOSE_URL}" -o /tmp/docker-compose \
    && echo "${DOCKER_COMPOSE_SHA256:-$(curl -sSL $DOCKER_COMPOSE_SHA256_URL | grep -Eo '^[^ ]+')}  /tmp/docker-compose" | sha256sum -c \
    && chmod +x /tmp/docker-compose

RUN curl -L "${KUBECTL_URL}" -o /tmp/kubectl \
    && echo "${KUBECTL_SHA256:-$(curl -sSL $KUBECTL_SHA256_URL)}  /tmp/kubectl" | sha256sum -c \
    && chmod +x /tmp/kubectl

RUN curl -L "${HELM_URL}" -o "/tmp/${HELM_ARCHIVE}" \
    && echo "${HELM_SHA256:-$(curl -sSL $HELM_SHA256_URL | grep -Eo '^[^ ]+')}  /tmp/${HELM_ARCHIVE}" | sha256sum -c \
    && tar -zxvf /tmp/${HELM_ARCHIVE} -C /tmp

RUN curl -L "${DOCKER_BUILDX_URL}" -o /tmp/docker-buildx \
    && echo "${DOCKER_BUILDX_SHA256}  /tmp/docker-buildx" | sha256sum -c \
    && chmod +x /tmp/docker-buildx

FROM amazon/aws-cli:${AWS_VERSION}

# Metadata
LABEL maintainer="Evil Martians <admin@evilmartians.com>"

RUN mkdir -p ~/.docker/cli-plugins \
    && echo '{"credsStore": "ecr-login"}' > ~/.docker/config.json

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
COPY --from=downloader /tmp/docker-compose /usr/local/bin/docker-compose
COPY --from=downloader /tmp/kubectl /usr/local/bin/kubectl
COPY --from=downloader /tmp/linux-amd64/helm /usr/local/bin/helm
COPY --from=downloader /tmp/docker-buildx /root/.docker/cli-plugins/docker-buildx

RUN amazon-linux-extras enable docker \
    && yum install --assumeyes amazon-ecr-credential-helper \
    && yum clean all

WORKDIR /root

ENTRYPOINT ["/bin/sh"]
