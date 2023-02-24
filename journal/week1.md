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
1. Created `run_flask.sh`
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
[Link to commit](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/e9415e20dbbf2b2936f077f3f2cf81f749a45c52)

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

gitpod /workspace/aws-bootcamp-cruddur-2023 (main) $ docker run -d --rm -p 4567:4567 -it -e FRONTEND_URL='*' -e BACKEND_URL='*' backend-flask
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

### Pushing and tagging image to Docker Hub
#### 1. Log in to Docker Hub
```sh
docker login
```
##### Log
```
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: *REDACTED*
Password: *REDACTED*
WARNING! Your password will be stored unencrypted in /home/gitpod/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
```
**WARNING! Your password will be stored unencrypted in /home/gitpod/.docker/config.json.** this looks like a potential problem. Remember to do `docker logout` in the end to remove the credentials from the `config.json`

#### 2. Tag the image
```sh
docker tag backend-flask nickda/cruddur-backend-flask:1.0
```

#### 3. Push the image to Docker Hub
```sh
docker push nickda/cruddur-backend-flask:1.0
```
##### Log
```
he push refers to repository [docker.io/nickda/cruddur-backend-flask]
0228ec85ec2a: Pushed 
97f998ea0f33: Pushed 
cb35014d1c7c: Pushed 
9aa90f80bdc0: Pushed 
5e8ed28e644d: Pushed 
66a7b77b1ced: Pushed 
223e3b83550e: Pushed 
53b2529dfca9: Mounted from library/python 
5be8f6899d42: Pushed 
8d60832b730a: Pushed 
63b3cf45ece8: Pushed 
1.0: digest: sha256:3750d50af5abd8f633f5219e0dd7df7a83efa557452b08d6f70a3c88f1688bbd size: 2617
```

#### 4. Verify in GUI that the image was indeed pushed
![CleanShot 2023-02-24 at 11 07 00](https://user-images.githubusercontent.com/10653195/221151371-65f9031e-5ce7-41ce-bf60-aa90c86bd061.png)


#### 5. Deleting the Docker Hub credentials from the ~/.docker/config.json
```sh
docker logout
```
##### Log
```
Removing login credentials for https://index.docker.io/v1/
```

### Multi-stage Build
[link to commit](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/cc2c12d4fa25291085fb2e362074efefadd17932)

MSB has the potential of making our container images smaller.
To determine whether that is the case let's check the size of our non-multi-stage container:

```sh
docker images backend-flask:latest
REPOSITORY      TAG       IMAGE ID       CREATED         SIZE
backend-flask   latest    55a3ed61463a   9 minutes ago   129MB <--- image size is here
```
#### Stage 1 - Building the application
In the first stage, the application is built by installing the required Python packages specified in requirements.txt. The --user flag is used to install packages in the local user's home directory instead of the system directory, and the --no-cache-dir flag is used to avoid caching the installed packages, which helps to reduce the final image size.

```dockerfile
FROM python:3.10-slim-buster AS builder

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install --user --no-cache-dir -r requirements.txt

COPY . .
```
#### Stage 2 - Running the application
In the second stage, the built application is copied from the first stage using the --from=builder flag, along with the Python packages installed in the first stage. The PATH environment variable is set to include the local user's home directory, so that the installed packages can be found when the application is run.

```dockerfile
FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH

COPY run_flask.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_flask.sh

ENV FLASK_ENV=development

EXPOSE ${PORT}

CMD [ "/usr/local/bin/run_flask.sh"]
```

#### After building the image we check the size again
```sh
docker images backend-flask:latest
REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
backend-flask   latest    5f1e02872672   33 seconds ago   122MB <--- Yay! We saved Gitpod 7MB of storage
```

