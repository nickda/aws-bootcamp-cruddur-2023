FROM python:3.10-slim-buster

WORKDIR /backend-flask

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt


COPY . .

COPY run_flask.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_flask.sh

ENV FLASK_ENV=development

EXPOSE ${PORT}

CMD [ "/usr/local/bin/run_flask.sh"]