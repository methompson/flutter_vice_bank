flutter clean
rm -rf .dart_tool
rm -rf build
rm pubspec.lock
rm .flutter-plugins
rm .flutter-plugins-dependencies
rm -rf docker/dist
rm -rf docker/artifacts

mkdir -p docker/dist
mkdir -p docker/artifacts

flutter pub get