# Builder layer with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will be
# overriden by `uv` when creating a virtual environment.
FROM python:3.13-slim AS builder
WORKDIR /app

RUN apt-get update && apt-get upgrade -y
RUN apt-get install pipx -y --no-install-recommends

# Equivalent to `pipx ensurepath`.
ENV PATH="/root/.local/bin:$PATH"
RUN pipx install uv

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev

ENV PATH="/app/.venv/bin:$PATH"

COPY . .

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

RUN groupadd app && \
    useradd --no-log-init -r -g app app-data && \
    chown -R app-data:app /app

USER app-data

ENTRYPOINT ["python3", "package/main.py"]