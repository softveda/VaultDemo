docker build -t todoapp src/TodoApp
docker images | grep -i todoapp
docker run -it --rm -p 8080:80 -e GREETING="Hello from Docker" --name todapp todoapp