# We use a hack to get static binaries as this reduces
# the final image size drastically and it is important
# to reduce deploy process duration.

ARG ALPINE_VERSION="3.12.0"

FROM docker:19.03.8 as static-docker-source
FROM alpine:${ALPINE_VERSION} as downloader

ARG DOCKER_COMPOSE_VERSION="1.25.5"
ARG DOCKER_COMPOSE_URL="https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64"
ARG DOCKER_COMPOSE_SHA256="1cb7ecccc17c8d5f1888f9e2b3211b07e35c86d0010a6c0f711fe65ef5b69528"

ARG KUBECTL_VERSION="v1.18.2"
ARG KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
ARG KUBECTL_SHA256="6ea8261b503c6c63d616878837dc70b758d4a3aeb9996ade8e83b51aedac9698"

ARG HELM_VERSION="v3.2.0"
ARG HELM_SHA256="4c3fd562e64005786ac8f18e7334054a24da34ec04bbd769c206b03b8ed6e457"
ARG HELM_ARCHIVE="helm-${HELM_VERSION}-linux-amd64.tar.gz"
ARG HELM_URL="https://get.helm.sh/${HELM_ARCHIVE}"

RUN apk -U --no-cache upgrade \
    && apk add --no-cache ca-certificates curl

RUN curl -L "${DOCKER_COMPOSE_URL}" -o /tmp/docker-compose \
    && echo "${DOCKER_COMPOSE_SHA256}  /tmp/docker-compose" | sha256sum -c \
    && chmod a+x /tmp/docker-compose

RUN curl -L "${KUBECTL_URL}" -o /tmp/kubectl \
    && echo "${KUBECTL_SHA256}  /tmp/kubectl" | sha256sum -c \
    && chmod a+x /tmp/kubectl

RUN curl -L "${HELM_URL}" -o "/tmp/${HELM_ARCHIVE}" \
    && echo "${HELM_SHA256}  /tmp/${HELM_ARCHIVE}" | sha256sum -c \
    && tar -zxvf /tmp/${HELM_ARCHIVE} -C /tmp

FROM amazon/aws-cli:2.0.12

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
