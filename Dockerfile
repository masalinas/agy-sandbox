# agy-sandbox: container to run Antigravity CLI (agy) isolated from the host
# Build:  docker build -t agy-sandbox .
# NOTE: not tested against the real installer; verify the install path (see below).

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Minimal tools a coding agent usually needs
RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates curl git ripgrep less \
        python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Non-root user (UID 1000 so files in mounted volumes don't end up owned by root)
# ubuntu:24.04 already ships a "ubuntu" user with UID 1000: replace it.
RUN userdel -r ubuntu 2>/dev/null || true \
    && useradd -m -u 1000 -s /bin/bash agent

USER agent
WORKDIR /home/agent

# Download the installer, review it (in class) and run it; do not pipe curl into bash.
# install.sh accepts no flags (--dir, --skip-aliases... belong to "agy install", not the script).
RUN curl -fsSL https://antigravity.google/cli/install.sh -o /tmp/install-agy.sh \
    && bash /tmp/install-agy.sh \
    && rm /tmp/install-agy.sh

# We don't know where the installer puts the binary: find it and link it into the PATH.
USER root
RUN set -e; \
    AGY_BIN="$(find /home/agent -type f -name agy -perm -u+x | head -n1)"; \
    if [ -z "$AGY_BIN" ]; then echo "agy not found after installation"; ls -laR /home/agent | head -50; exit 1; fi; \
    echo "agy installed at: $AGY_BIN"; \
    ln -sf "$AGY_BIN" /usr/local/bin/agy
USER agent

# Build-time check: fails if agy doesn't work
RUN agy --version

# Entrypoint: applies the optional first-run configuration when AGY_AUTOCONFIG=true (see entrypoint.sh)
COPY --chown=agent:agent --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# The student's repo is mounted here at runtime
WORKDIR /workspace
USER root
RUN mkdir -p /workspace && chown agent:agent /workspace
USER agent

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["bash"]