docker stop template
docker rm $(docker ps -q -f status=exited)
docker run --name template -d p 3838:3838 oydeu/app-template
