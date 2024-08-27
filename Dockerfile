FROM python:3.11

ENV PYTHONUNBUFFERED=1

RUN pip3 install virtualenv poetry \
  && poetry config virtualenvs.create false

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
