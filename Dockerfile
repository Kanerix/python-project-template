# Builder layer with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will
# be overriden by `uv` when creating a virtual environment.
FROM python AS builder
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

ENV PATH="/root/.cargo/bin/:$PATH"

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev -v

COPY . .

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev -v


FROM python:slim-bookworm AS runner
COPY --from=builder --chown=app:app /app /app

ENV PATH="/app/.venv/bin:$PATH"

RUN groupadd app && \
    useradd --no-log-init -r -g app app-data && \
    chown -R app-data:app /app

USER app-data

ENTRYPOINT ["python3", "package/main.py"]