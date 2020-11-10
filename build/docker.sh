docker build -t todoapp src/TodoApp
docker images | grep -i todoapp
docker run -it --rm -p 8080:80 -e GREETING="Hello from Docker" --name todoapp todoapp
docker run -it --rm -p 8080:80 \
  -e GREETING="Hello from Docker" \
  -e DB_SERVER="tcp:moviesqlserver.database.windows.net" \
  -e DB_USER="SqlUser" \
  -e DB_PASSWORD="Pa55w.rd1234" \
  --name todoapp todoapp