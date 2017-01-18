docker build -t oydeu/app-template .
docker push oydeu/app-template
docker stop template
docker rm $(docker ps -q -f status=exited)
docker run --name template -d --expose 3838 -e VIRTUAL_HOST=template.datentresor.org -e VIRTUAL_PORT=3838 oydeu/app-template
