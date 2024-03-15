rm -rf build/web
rm -rf docker/artifacts

mkdir -p docker/artifacts

flutter build web --release

mv build/web docker/artifacts

(
  cd docker && \
  docker build -t vice_bank_app .
)