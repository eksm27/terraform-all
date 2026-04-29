#FROM python:3.11-slim
#
#WORKDIR /code
#
#COPY . .
#
#RUN pip install --no-cache-dir -r requirements.txt
#
#ENV PYTHONPATH=/code
#
#CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]

FROM python:3.11-slim

WORKDIR /code

COPY . /code/app/

RUN pip install --no-cache-dir -r /code/app/requirements.txt

ENV PYTHONPATH=/code

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]