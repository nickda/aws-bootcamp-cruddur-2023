# Week 1 — App Containerization

### Difference between RUN and CMD
`RUN` is a command we run to create a layer in the image / `CMD` is a command that the container is going to run when it starts up

### Containerize Backend and Frontend

#### Checked that the python works independent of Docker

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


#### Docker Config
- Added Dockerfiles for backend and frontent and docker-compose.yml: [Link to commit 4771c99](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/4771c996b8aea77c5244c0025e5b0f41fa519357?diff=split)

#### Tried building the container

```sh
docker build -t backend-flask ./backend-flask
```

#### Tried Running the Container

Run 
```sh
docker run --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
```

Tried returning the container id into an Env Var
```sh
CONTAINER_ID=$(docker run --rm -p 4567:4567 -d backend-flask)
env | grep CONTAINER
```

#### Get Container Images or Running Container Ids

```
docker ps
docker images
```

#### Checked Container Logs

```sh
docker logs CONTAINER_ID -f
docker logs backend-flask -f
docker logs $CONTAINER_ID -f
```

#### Tried attaching shell to a Container

```sh
docker exec CONTAINER_ID -it /bin/bash
```

#### Added "npm install" to gitpod.yml to avoid running it manually
[Link to commit 5714650](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/5714650999ee46c699806c6d410fc14987acb6ca)

#### Three ways of running Docker compose
```sh
docker compose up
docker-compose up
#Right-click on the file in VSC and choose "Compose UP"
```

### Updating the OpenAPI definitions
[Link to commit d4185e0](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/d4185e0b70f4d481882dfc95f79995550d8684b2)

### Updating the backend and frontend code to add notifications functionality
[Link to commit db7fc6f](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/db7fc6fd36ac70e7ea80d77403598c675e0e02aa)


### DynamoDB Local and PostgreSQL

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

## Homework Challenges
### Run the Dockerfile CMD as an external script
1. Created run_flask.sh
```bash
#!/bin/bash
python3 -m flash run --host=0.0.0.0 --port=4567
```
2. Built the container
```sh
docker build -t backend-flask ./backend-flask
```
3. Ran the container
```sh
docker run -d --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
```
#### Log
```sh
gitpod /workspace/aws-bootcamp-cruddur-2023 (main) $ docker build -t backend-flask ./backend-flask
Sending build context to Docker daemon  60.93kB
Step 1/10 : FROM python:3.10-slim-buster
 ---> b5d627f77479
Step 2/10 : WORKDIR /backend-flask
 ---> Using cache
 ---> dab5faf8aaa4
Step 3/10 : COPY requirements.txt requirements.txt
 ---> Using cache
 ---> 23f30b13d8ec
Step 4/10 : RUN pip3 install -r requirements.txt
 ---> Using cache
 ---> d940517a0a09
Step 5/10 : COPY . .
 ---> Using cache
 ---> 20edee9a7fde
Step 6/10 : COPY run_flask.sh /usr/local/bin/
 ---> Using cache
 ---> dcd90cd3e728
Step 7/10 : RUN chmod +x /usr/local/bin/run_flask.sh
 ---> Using cache
 ---> aa1211fad82a
Step 8/10 : ENV FLASK_ENV=development
 ---> Using cache
 ---> ee3b5416f8ea
Step 9/10 : EXPOSE ${PORT}
 ---> Using cache
 ---> ca7136f2cb16
Step 10/10 : CMD [ "/usr/local/bin/run_flask.sh"]
 ---> Using cache
 ---> 2de9bf49876f
Successfully built 2de9bf49876f
Successfully tagged backend-flask:latest
gitpod /workspace/aws-bootcamp-cruddur-2023 (main) $ docker run --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
 * Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
 * Running on all addresses (0.0.0.0)
 * Running on http://127.0.0.1:4567
 * Running on http://172.17.0.2:4567
Press CTRL+C to quit
 * Restarting with stat
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
'FLASK_ENV' is deprecated and will not be used in Flask 2.3. Use 'FLASK_DEBUG' instead.
 * Debugger is active!
 * Debugger PIN: 113-469-523
^Cgitpod /workspace/aws-bootcamp-cruddur-2023 (main) $ docker run -d --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
66c58f329e6f0f7f85ee5ce7939b38f940d7b5b263461296173fcd38bb4fe4cf
gitpod /workspace/aws-bootcamp-cruddur-2023 (main) $ curl https://4567-nickda-awsbootcampcrudd-su9p9lpj1ju.ws-eu87.gitpod.io/api/activities/home
[
  {
    "created_at": "2023-02-22T09:32:27.981983+00:00",
    "expires_at": "2023-03-01T09:32:27.981983+00:00",
    "handle": "Andrew Brown",
    "likes_count": 5,
    "message": "Cloud is fun!",
    "replies": [
      {
        "created_at": "2023-02-22T09:32:27.981983+00:00",
... edited for brevity
```
