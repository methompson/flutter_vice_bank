./scripts/docker_build_amd64.sh

(
  cd docker && \
  rm -rf dist
  mkdir dist
  docker save vice_bank_app -o ./dist/vice_bank_app.tar
)