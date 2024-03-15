(
  cd docker && \
  docker run \
  --rm \
  -p 3002:80 \
  --name vice_bank_app \
  vice_bank_app
)