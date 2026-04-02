FROM python:3.11

WORKDIR /app

RUN apt-get update && apt-get install -y jq

COPY . .

RUN pip install flask boto3 mysql-connector-python

RUN chmod +x entrypoint.sh

EXPOSE 9090

ENTRYPOINT ["./entrypoint.sh"]