# Create a base image with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will be
# overriden by `poetry`.
FROM python:alpine3.20 AS base
WORKDIR /app

RUN apk update && sudo apk upgrade --no-cache \
    apk add pipx

RUN pipx install poetry


# Build dependencies in independant step so we only rebuild when
# they changes (dependency caching).
FROM base AS depedency
WORKDIR /app

ADD pyproject.toml poetry.lock ./

RUN poetry install


# Build application
FROM base AS builder
WORKDIR /app

ADD . .


FROM python:alpine3.20 AS runner
WORKDIR /var/app

RUN addgroup -S app && \
    adduser -S dae -G app && \
    chown -R dae:app /var/app

USER dae

# EXPOSE 3000 <-- Only expose ports if necessary

ENTRYPOINT ["python", "/var/app/"]