rm -rf build/web
rm -rf docker/artifacts
mkdir -p docker/artifacts

flutter build web --release

mv build/web docker/artifacts

(
  cd docker && \
  docker buildx build \
  --platform=linux/amd64 \
  -t vice_bank_app .
)