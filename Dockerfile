# We use a hack to get static binaries as this reduces
# the final image size drastically and it is important
# to reduce deploy process duration.

ARG DOCKER_VERSION="20.10.3"
ARG ALPINE_VERSION="3.13.1"
ARG AWS_VERSION="2.1.23"

FROM docker:${DOCKER_VERSION} as static-docker-source
FROM alpine:${ALPINE_VERSION} as downloader

ARG DOCKER_COMPOSE_VERSION="1.28.2"
ARG DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64"
ARG DOCKER_COMPOSE_SHA256
ARG DOCKER_COMPOSE_SHA256_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64.sha256"

ARG KUBECTL_VERSION="v1.20.2"
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ARG KUBECTL_SHA256
ARG KUBECTL_SHA256_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256"

ARG HELM_VERSION="v3.5.2"
ARG HELM_SHA256
ARG HELM_SHA256_URL="https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz.sha256sum"
ARG HELM_ARCHIVE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_URL="https://get.helm.sh/${HELM_ARCHIVE}"

RUN apk -U --no-cache upgrade \
    && apk add --no-cache ca-certificates curl

RUN curl -L "${DOCKER_COMPOSE_URL}" -o /tmp/docker-compose \
    && echo "${DOCKER_COMPOSE_SHA256:-$(curl -sSL $DOCKER_COMPOSE_SHA256_URL | grep -Eo '^[^ ]+')}  /tmp/docker-compose" | sha256sum -c \
    && chmod +x /tmp/docker-compose

RUN curl -L "${KUBECTL_URL}" -o /tmp/kubectl \
    && echo "${KUBECTL_SHA256:-$(curl -sSL $KUBECTL_SHA256_URL)}  /tmp/kubectl" | sha256sum -c \
    && chmod +x /tmp/kubectl

RUN curl -L "${HELM_URL}" -o "/tmp/${HELM_ARCHIVE}" \
    && echo "${HELM_SHA256:-$(curl -sSL $HELM_SHA256_URL | grep -Eo '^[^ ]+')}  /tmp/${HELM_ARCHIVE}" | sha256sum -c \
    && tar -zxvf /tmp/${HELM_ARCHIVE} -C /tmp

FROM amazon/aws-cli:${AWS_VERSION}

# Metadata
LABEL maintainer="Evil Martians <admin@evilmartians.com>"

COPY --from=static-docker-source /usr/local/bin/docker /usr/local/bin/docker
COPY --from=downloader /tmp/docker-compose /usr/local/bin/docker-compose
COPY --from=downloader /tmp/kubectl /usr/local/bin/kubectl
COPY --from=downloader /tmp/linux-amd64/helm /usr/local/bin/helm

RUN amazon-linux-extras enable docker \
    && yum install --assumeyes amazon-ecr-credential-helper \
    && yum clean all

RUN mkdir -p ~/.docker \
    && echo '{"credsStore": "ecr-login"}' > ~/.docker/config.json

WORKDIR /root

ENTRYPOINT ["/bin/sh"]
