FROM registry.access.redhat.com/ubi8/python-39

LABEL maintainer="your-email@example.com"

WORKDIR /app

COPY . /app

RUN pip install -r requirements.txt

EXPOSE 8080

CMD ["python", "app.py"]

