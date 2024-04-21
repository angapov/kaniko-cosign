ARG COSIGN_VERSION=v2.2.3
ARG VAULT_VERSION=1.14
FROM gcr.io/projectsigstore/cosign:$COSIGN_VERSION AS cosign
FROM hashicorp/vault:$VAULT_VERSION AS vault
FROM gcr.io/kaniko-project/executor:debug AS kaniko
FROM debian:bookworm-slim
COPY --from=cosign /ko-app/cosign /usr/local/bin/cosign
COPY --from=vault /bin/vault /usr/local/bin/vault
COPY --from=kaniko /kaniko /kaniko
ENV PATH=$PATH:/usr/local/bin:/kaniko \
    DOCKER_CONFIG=/kaniko/.docker
RUN apt-get update &&\
    apt-get install -y ca-certificates curl
WORKDIR /workspace
CMD ["/bin/sh"]
