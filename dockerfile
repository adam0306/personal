FROM ubuntu:latest
#https://hub.docker.com/r/whiteoaksecurity/docker-eyewitness/~/dockerfile/
#https://github.com/ChrisTruncer/EyeWitness
#https://www.christophertruncer.com/eyewitness-2-0-release-and-user-guide/

RUN apt-get update && apt-get install -y git wget phantomjs && rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/ChrisTruncer/EyeWitness.git

WORKDIR /EyeWitness/setup
RUN ./setup.sh

RUN mkdir /tmp/EyeWitness
WORKDIR /tmp/EyeWitness/
ENTRYPOINT ["python", "/EyeWitness/EyeWitness.py", "--no-prompt"]