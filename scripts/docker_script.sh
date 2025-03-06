appName=vice_bank_app
registryUrl=con.kakomu.com

runContainer() {
  docker run \
    -d \
    -p 3002:80 \
    --name vice_bank_app \
    vice_bank_app
}

restartContainer() {
  printf "Restarting %s\n" $appName
  docker restart $appName
}

stopContainer() {
  printf "Stopping %s\n" $appName
  docker stop $appName
}

compileApp() {
  rm -rf dist
  rm -rf docker/artifacts
  mkdir -p docker/artifacts

  flutter pub get
  flutter build web --release

  mv build/web docker/artifacts
}

buildContainer() {
  compileApp
  (
    cd docker && \
    docker build -t $appName .
  )
}

buildAMD64Container() {
  compileApp

  (
    cd docker
    docker buildx build \
      --platform=linux/amd64 \
      -t $appName .
  )
}

exportContainer() {
  (
    cd docker
    rm -rf dist
    mkdir dist
    docker save $appName -o ./dist/$appName.tar
  )
}

uploadImage() {
  docker load -i docker/dist/$appName.tar
  docker tag $appName $registryUrl/$appName
  docker push $registryUrl/$appName
}

registryLogin() {
  docker login $registryUrl --username methompson
}

showContainerLogs() {
  docker logs $appName
}

tailContainerLogs() {
  docker logs $appName --follow
}

isContainerRunning() {
  containerRunning=`docker container ls -f "name=$appName" -q | wc -l`
  return "$containerRunning"
}

getUserInput() {
  printf "\n\nThis script should be run from the root directory of the project\n\n"

  if [ $containerRunning -eq 1 ]
  then
    printf "%s is running" $appName
    containerRunningMenu
  else
    printf "%s is not running" $appName
    containerNotRunningMenu
  fi
}

containerRunningMenu() {
  printf "\n\nWhat do you want to do?\n\n"
  printf "1. Restart %s\n" $appName
  printf "2. Stop %s\n" $appName
  printf "3. Show logs of %s\n" $appName
  printf "4. Tail logs of %s\n" $appName
  printf "5. Build %s\n" $appName
  printf "6. Build and Export %s for current processor architecture\n" $appName
  printf "7. Build and Export %s for AMD64 architecture\n" $appName
  printf "8. Upload %s to registry\n" $appName
  printf "9. Build and Upload AMD64 image of %s to registry\n" $appName
  printf "10. Login to registry\n"
  printf "Any other key exits\n"
  read -p "Select: " selection

  if [[ $selection == 1 ]]
  then
    restartContainer
  elif [[ $selection == 2 ]]
  then
    stopContainer
  elif [[ $selection == 3 ]]
  then
    showContainerLogs
  elif [[ $selection == 4 ]]
  then
    tailContainerLogs
  elif [[ $selection == 5 ]]
  then
    buildContainer
  elif [[ $selection == 6 ]]
  then
    buildContainer
    exportContainer
  elif [[ $selection == 7 ]]
  then
    buildAMD64Container
    exportContainer
  elif [[ $selection == 8 ]]
  then
    uploadImage
  elif [[ $selection == 9 ]]
  then
    buildAMD64Container
    uploadImage
  elif [[ $selection == 10 ]]
  then
    registryLogin
  else
    printf "Exiting\n\n"
    exit 1
  fi
}

containerNotRunningMenu() {
  printf "\n\nWhat do you want to do?\n\n"
  printf "1. Run %s\n" $appName
  printf "2. Build %s\n" $appName
  printf "3. Build and Export %s for current processor architecture\n" $appName
  printf "4. Build and Export %s for AMD64 architecture\n" $appName
  printf "5. Upload %s to registry\n" $appName
  printf "6. Build, Export, and Upload %s to registry\n" $appName
  printf "7. Login to registry\n"
  printf "Any other key exits\n"
  read -p "Select: " selection

  if [[ $selection == 1 ]]
  then
    runContainer
  elif [[ $selection == 2 ]]
  then
    buildContainer
  elif [[ $selection == 3 ]]
  then
    buildContainer
    exportContainer
  elif [[ $selection == 4 ]]
  then
    buildAMD64Container
    exportContainer
  elif [[ $selection == 5 ]]
  then
    uploadImage
  elif [[ $selection == 6 ]]
  then
    buildAMD64Container
    exportContainer
    uploadImage
  elif [[ $selection == 7 ]]
  then
    registryLogin
  else
    printf "Exiting\n\n"
    exit 1
  fi
}

isContainerRunning
containerRunning=$?

getUserInput