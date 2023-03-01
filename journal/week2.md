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
[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/4352fdb96f8c0dcc5d3bcef62b5fc8ee6e17ba4b)

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

### Add instrumentation lines to app.py
[commit link](https://github.com/nickda/aws-bootcamp-cruddur-2023/commit/a9d4da62712164170d4ee43251401bef10e13da8)
Ensure that initialize automatic instrumentation instructions go after the `app = Flask(__name__)`

### docker-compose up and Dataset in Honeycomb
After running docker-compose up, the data set appeared in Honeycomb:
![CleanShot 2023-03-01 at 18 32 45](https://user-images.githubusercontent.com/10653195/222217438-f8ddbf22-a3c1-4a4c-9676-72fdd603b4f7.png)

We can also see the spans here:
![CleanShot 2023-03-01 at 19 06 12](https://user-images.githubusercontent.com/10653195/222224793-1480ba50-d82b-448c-82d6-8a52d9cc944b.png)

#### Troubleshooting if things don't work
1. Check your HONEYCOMB_API_KEY and figure out which environment it's going to here: https://honeycomb-whoami.glitch.me
2. Try exporting the spans to STDOUT

in app.py add the following:
```py
from opentelemetry.sdk.trace.export import ConsoleSpanExporter, SimpleSpanProcessor

simple_processor = SimpleSpanProcessor(ConsoleSpanExporter())
provider.add_span_processor(simple_processor)
```

### Adding a Span into the code
[Honeycomb Python Doc](https://docs.honeycomb.io/getting-data-in/opentelemetry/python/)

#### Acquiring a tracer
in `home_activities.py`:
```py
from opentelemetry import trace
tracer = trace.get_tracer("home.activities")
```
#### Creating a Span
in `home_activities.py`:
  in class `HomeActivities`:
    in def `run()`:
    ```py
    with tracer.start_as_current_span("home-activities-mock-data"):
      now = datetime.now (timezone.utc).astimezone ()
      <rest of the body of the function>
    ```
#### Testing
```sh
docker compose down
docker compose up
```
I can now see the newly created span in the Honeycomb UI:
![CleanShot 2023-03-01 at 19 18 36](https://user-images.githubusercontent.com/10653195/222227425-6df1dab7-6f79-491a-85e8-b1729e589a6d.png)
Main trace:
![CleanShot 2023-03-01 at 19 19 52](https://user-images.githubusercontent.com/10653195/222227669-d643e8fd-8822-44d9-a66d-99581e38846c.png)
Mock data span:
![CleanShot 2023-03-01 at 19 20 12](https://user-images.githubusercontent.com/10653195/222227776-3869db48-657b-4a54-9841-b15ea0414d5f.png)

### Adding attributes to the Span
in `home_activities.py`:
  in class `HomeActivities`:
    in def `run()`:
    ```py
    with tracer.start_as_current_span("home-activities-mock-data"):
      span = trace.get_current_span()
      now = datetime.now(timezone.utc).astimezone()
      span.set_attribute("app.now", now.isoformat())
      <rest of the body of the function>
      span.set_attribute("app.result_length", len(results))
      return results
    ```

Honeycomb Query [VISUALIZE: COUNT] [GROUP BY: trace.trace_id] results:
![CleanShot 2023-03-01 at 19 30 24](https://user-images.githubusercontent.com/10653195/222231748-ce1f4e3f-aba7-43f9-8edf-6f3d99a824a9.png)

![CleanShot 2023-03-01 at 19 32 50](https://user-images.githubusercontent.com/10653195/222232725-3127d6ba-5118-47da-8542-9fae4fe05b81.png)

HEATMAP for 90th percentile of duration:
![CleanShot 2023-03-01 at 19 36 12](https://user-images.githubusercontent.com/10653195/222233722-a07f3e19-5e26-4f07-ac81-5df33ed308e5.png)

![CleanShot 2023-03-01 at 19 37 02](https://user-images.githubusercontent.com/10653195/222233813-38bddc6d-1938-4302-8a13-6835f2aa1b87.png)


## Adding ports in .gitpod.yml
To avoid manually opening ports every time, added ports to .gitpod.yml
```yml
ports:
  - name: frontend
    port: 3000
    onOpen: open-browser
    visibility: public
  - name: backend
    port: 4567
    visibility: public
  - name: xray-daemon
    port: 2000
    visibility: public
```
    




