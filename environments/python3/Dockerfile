FROM python:3.7.6-slim-buster

RUN apt-get update && \
    apt-get install -y build-essential

RUN pip install \
    requests \
    beautifulsoup4 \
    pycrypto \
    cryptography \
    urllib3 

RUN apt-get purge -y build-essential
RUN apt-get autoremove -y

CMD ["python", "-c", "print('f')"]
