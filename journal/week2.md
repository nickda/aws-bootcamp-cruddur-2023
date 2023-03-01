# Week 2 — Distributed Tracing

## Honeycomb setup and instrumenting the code
### Create environment called bootcamp-dev
You can use environments to segment dev/test/prod
![CleanShot 2023-03-01 at 11 22 37](https://user-images.githubusercontent.com/10653195/222111950-20d04fd0-58a0-4d5d-bb10-d4fcd0dfa571.png)

>API keys determine which environment the data will land in

### Grab the key for the environment
![CleanShot 2023-03-01 at 11 23 29](https://user-images.githubusercontent.com/10653195/222112325-2aab8d87-b8ea-499c-b2de-ab769ebbab3f.png)

### In GitPod Export the key into envvar and `gp env`:
```sh
export HONEYCOMB_API_KEY="REDACTED"
gp env HONEYCOMB_API_KEY="REDACTED"
```

### Edit docker-compose.yml to add OpenTelemetry variables for the backend-flask service
>The HONEYCOMB_SERVICE_NAME should not be set globally. It should be set per service.

```yml
services:
  backend-flask:
    environment:
      FRONTEND_URL: "https://3000-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      BACKEND_URL: "https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
      OTEL_SERVICE_NAME: "backend-flask" # <----<<-
      OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io" # <----<<-
      OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}" # <----<<-
```

>OTEL = Open Telemetry
>These are open source libraries. Part of CNCF.
>These standardised messages are sent to Honeycomb.
![CleanShot 2023-03-01 at 11 36 30](https://user-images.githubusercontent.com/10653195/222115477-4ffa88ab-88e3-44b4-a061-c073d44c3fca.png)

### Install the Python modules for OpenTelemetry
```sh
pip install opentelemetry-api \
    opentelemetry-sdk \
    opentelemetry-exporter-otlp-proto-http \
    opentelemetry-instrumentation-flask \
    opentelemetry-instrumentation-requests
```
>These commands can be accessed if you click on the "Home" button in Honeycomb UI
#### Save the modules into requirements.txt
```sh
pip freeze >> requirements.txt
```

