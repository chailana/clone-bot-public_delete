FROM ubuntu:latest

WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
RUN chmod 777 /usr/src/app
ENV DEBIAN_FRONTEND="noninteractive"

# Install dependencies
RUN apt-get -y update && apt-get install -y \
    apt-utils python3 python3-pip python3-venv wget \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq ffmpeg \
    locales git unzip rtmpdump libmagic-dev libcurl4-openssl-dev \
    libssl-dev libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev \
    libjpeg-dev zlib1g-dev libpng-dev && \
    locale-gen en_US.UTF-8

# Set up environment variables
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

# Create a virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright dependencies and Playwright itself
RUN playwright install-deps
RUN playwright install

# Copy the rest of the project
COPY . .

# Start the application
CMD ["bash", "start.sh"]
