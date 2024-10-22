# Create a base image with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will be
# overriden by `uv` when creating a virtual environment.
FROM python:3.13 AS builder
WORKDIR /app

RUN apt-get update && apt-get upgrade

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

COPY pyproject.toml uv.lock ./

    # Create virtualenvs in project root instead of poetry's default location.
RUN poetry config virtualenvs.in-project true && \
    # Make sure lock file is up-to-date with dependencies
    poetry lock --no-interaction --no-ansi -vvv --no-update && \
    # Install only main dependencies (hidden group)
    poetry install --no-interaction --no-ansi -vvv --only main


FROM python:3.13-slim AS runner
WORKDIR /app

COPY --from=builder /app/.venv ./.venv
COPY . .

RUN groupadd app && \
    useradd --no-log-init -r -g app app-data && \
    chown -R app-data:app /app

USER app-data

# Expose only if necessary
# EXPOSE 3000

ENTRYPOINT [".venv/bin/python3", "package/main.py"]