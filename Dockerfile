FROM ubuntu:22.04
ENV HUGO_VERSION=0.115.1

RUN apt update && apt upgrade -y 
RUN apt install wget snapd -y 
RUN wget -O /hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb && dpkg -i /hugo.deb 

WORKDIR /src