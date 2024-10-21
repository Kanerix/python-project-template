# Create a base image with updated and shared dependecies installed.
#
# The python version here does not acctually matter since it will be
# overriden by `poetry` when creating a virtual environment.
FROM python:slim AS base
WORKDIR /app

RUN apt-get update && apt-get upgrade -y && apt-get clean
RUN apt-get install pipx -y --no-install-recommends

# Equivalent to `pipx ensurepath`.
ENV PATH="/root/.local/bin:$PATH"
RUN pipx install poetry


FROM base AS builder
WORKDIR /app

ADD pyproject.toml poetry.lock ./

RUN poetry config virtualenvs.in-project true && \
    poetry lock --no-interaction --no-ansi -vvv --no-update && \
    poetry install --no-interaction --no-ansi -vvv --only main


FROM base AS runner
WORKDIR /app

COPY --from=builder /app/.venv ./.venv
ADD . .

RUN groupadd app && \
    useradd -d /var/app -g app app-data && \
    chown -R app-data:app /app

USER app-data

# EXPOSE 3000 <-- Only expose if necessary

ENTRYPOINT [".venv/bin/python3", "[package]/main.py"]