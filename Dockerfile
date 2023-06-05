FROM alpine:3.11
ARG VCS_REF
ARG BUILD_DATE
# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
ENV KUBE_LATEST_VERSION="v1.18.2"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v3.2.1"
# Note: Latest version of docker may be found at:
# https://download.docker.com/linux/static/stable/x86_64/
ARG DOCKER_CLI_VERSION="19.03.8"

ARG ARGO_CLI_VERSION="3.2.3"


RUN apk add --no-cache ca-certificates bash git openssh curl jq \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \ 
    && mkdir -p /tmp/download \
    && curl -L https://download.docker.com/linux/static/stable/x86_64/docker-$DOCKER_CLI_VERSION.tgz | tar -xz -C /tmp/download \
    && mv /tmp/download/docker/docker /usr/local/bin/ \
    && wget https://github.com/argoproj/argo-workflows/releases/download/v$ARGO_CLI_VERSION/argo-darwin-amd64.gz -O "/tmp/download/argo-darwin-amd64.gz" \
	&& gunzip /tmp/download/argo-darwin-amd64.gz \
    && mv /tmp/download/argo-darwin-amd64 /usr/local/bin/argocli \    
    && rm -rf /tmp/download \
    && rm -rf /var/cache/apk/*
WORKDIR /config
CMD bash
