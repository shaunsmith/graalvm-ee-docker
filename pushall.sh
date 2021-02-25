docker images | grep graalvm | awk '{system("docker push " $1 ":" $2 )}'
