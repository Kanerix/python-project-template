# Builder layer with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will
# be overriden by `uv` when creating a virtual environment.
FROM python:slim-bookworm
WORKDIR /app

ENV PYTHONUNBUFFERED=1

COPY --from=ghcr.io/astral-sh/uv:0.4.28 /uv /uvx /bin/
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    uv sync --frozen --no-install-project --no-dev -v

COPY . .

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev -v

ENTRYPOINT ["python3", "package/main.py"]