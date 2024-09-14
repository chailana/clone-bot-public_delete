FROM ubuntu:latest

WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
RUN chmod 777 /usr/src/app
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && apt-get install -y apt-utils && \
    apt-get install -y python3 python3-pip python3-venv wget \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq ffmpeg \
    locales git unzip rtmpdump libmagic-dev libcurl4-openssl-dev \
    libssl-dev libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev \
    && locale-gen en_US.UTF-8

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# Create a virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN playwright install-deps
RUN playwright install

COPY . .

CMD ["bash", "start.sh"]
