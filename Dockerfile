FROM alpine:latest AS builder

ENV UID=10001
ENV GID=10001
ENV USER=terraform
ENV GROUP="$USER"
ENV HOME=/
ENV SHELL=/sbin/nologin

RUN set -euxo pipefail && \
    addgroup -g "$GID" -S "$GROUP" && \
    adduser --disabled-password --gecos "" --uid "$UID" --ingroup "$GROUP" --no-create-home --home "$HOME" --shell "$SHELL" "$USER"


FROM hashicorp/terraform:1.3.6 AS release

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --chown=terraform:terraform .infrastructure/terraform /opt/terraform

USER terraform

WORKDIR /opt/terraform

ENTRYPOINT ["/bin/terraform"]
