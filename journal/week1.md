# Week 1 — App Containerization

## Difference between RUN and CMD
`RUN` is a command we run to create a layer in the image / `CMD` is a command that the container is going to run when it starts up

## Containerize Backend and Frontend

### Checked that the python works independent of Docker

```sh
cd backend-flask
export FRONTEND_URL="*"
export BACKEND_URL="*"
python3 -m flask run --host=0.0.0.0 --port=4567
cd ..
```

- port unlocked
- successfully opened port 4567
- got back JSON response


### Docker Config
- Added Dockerfiles for backend and frontent and docker-compose.yml
[Link to commit 4771c99](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/4771c996b8aea77c5244c0025e5b0f41fa519357?diff=split)

### Tried building the container

```sh
docker build -t  backend-flask ./backend-flask
```

### Tried Running the Container

Run 
```sh
docker run --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
```

Tried returning the container id into an Env Var
```sh
CONTAINER_ID=$(docker run --rm -p 4567:4567 -d backend-flask)
env | grep CONTAINER
```

### Get Container Images or Running Container Ids

```
docker ps
docker images
```

### Checked Container Logs

```sh
docker logs CONTAINER_ID -f
docker logs backend-flask -f
docker logs $CONTAINER_ID -f
```

### Tried attaching shell to a Container

```sh
docker exec CONTAINER_ID -it /bin/bash
```

### Added "npm install" to gitpod.yml to avoid running it manually
[Link to commit 5714650](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/5714650999ee46c699806c6d410fc14987acb6ca)

### Three ways of running Docker compose
```sh
docker compose up
docker-compose up
#Right-click on the file in VSC and choose "Compose UP"
```

## Updating the OpenAPI definitions
[Link to commit d4185e0](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/d4185e0b70f4d481882dfc95f79995550d8684b2)

## Updating the backend and frontend code to add notifications functionality
[Link to commit db7fc6f](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/db7fc6fd36ac70e7ea80d77403598c675e0e02aa)


## DynamoDB Local and PostgreSQL

Modifying docker-compose to include databases: [Link to commit a3e9641](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/a3e964144996e84ed031a65bc65df63a19f25573)

Used the "Other Explorer" installed in VSC to connect to Postgres:
![CleanShot 2023-02-24 at 08 50 14](https://user-images.githubusercontent.com/10653195/221122516-48edec2c-30d5-4e6a-b951-93cedf675493.png)

Can see the standard tables:

![CleanShot 2023-02-24 at 08 52 29](https://user-images.githubusercontent.com/10653195/221122842-8f5c152e-1141-48e8-9579-64c00f5a9a40.png)

Tried connecting via CLI client:
```sh
sudo apt-get install -y postgresql-client
psql -h localhost -U postgres
```
![CleanShot 2023-02-24 at 08 56 13](https://user-images.githubusercontent.com/10653195/221123666-ed275f05-c672-46ec-bed2-5b3885717449.png)
