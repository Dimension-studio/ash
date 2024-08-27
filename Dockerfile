FROM python:3.11

ENV PYTHONUNBUFFERED=1

RUN pip3 install virtualenv poetry \
  && poetry config virtualenvs.create false

# Install virtualenv, poetry, and Docker CLI
RUN apt-get update && \
    apt-get install -y \
    docker.io \
    && pip3 install virtualenv poetry \
    && poetry config virtualenvs.create false \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ash
COPY ./pyproject.toml /ash/pyproject.toml
RUN poetry install --no-interaction --no-ansi

COPY ./ash /ash/ash

# Add a script to log in to GHCR and run the main application
COPY entrypoint.sh /ash/entrypoint.sh
RUN chmod +x /ash/entrypoint.sh

# Set the entrypoint to our custom script
ENTRYPOINT ["/ash/entrypoint.sh"]

CMD ["python", "-m", "ash"]
