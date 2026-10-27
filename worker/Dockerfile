# because of dotnet, we always build on amd64, and target platforms in cli
# dotnet doesn't support QEMU for building or running.
# (errors common in arm/v7 32bit) https://github.com/dotnet/dotnet-docker/issues/1537
# https://hub.docker.com/_/microsoft-dotnet
# hadolint ignore=DL3029
# to build for a different platform than your host, use --platform=<platform>
# for example, if you were on Intel (amd64) and wanted to build for ARM, you would use:
# docker buildx build --platform "linux/arm64/v8" .

# build compiles the program for the builder's local platform
FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0@sha256:d32bd65cf5843f413e81f5d917057c82da99737cb1637e905a1a4bc2e7ec6c8d AS build
ARG TARGETPLATFORM
ARG TARGETARCH
ARG BUILDPLATFORM
RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

WORKDIR /source
COPY *.csproj .
RUN dotnet restore -a $TARGETARCH

COPY . .
RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore

# app image: .NET 7 runtime on Debian 12 (the default 7.0 tag is Debian 11,
# which no longer receives security updates)
FROM mcr.microsoft.com/dotnet/runtime:7.0-bookworm-slim@sha256:f24ddd398454193219bd21979029cdefb51fcda577a497eff519c84ac736c110

# apply Debian security fixes
RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

# Create an unprivileged user to run the app
RUN groupadd --system --gid 10001 appuser && \
    useradd --system --uid 10001 --gid appuser --no-create-home --shell /usr/sbin/nologin appuser

WORKDIR /app
COPY --from=build --chown=appuser:appuser /app .

# Run as the unprivileged user
USER appuser

ENTRYPOINT ["dotnet", "Worker.dll"]
