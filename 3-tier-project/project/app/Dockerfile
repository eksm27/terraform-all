FROM python:3.11

WORKDIR /app

RUN apt-get update && apt-get install -y jq

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

RUN chmod +x entrypoint.sh

EXPOSE 9090

ENTRYPOINT ["./entrypoint.sh"]