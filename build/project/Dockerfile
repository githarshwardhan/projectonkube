FROM ubuntu:20.04

MAINTAINER anandd@valueaddsofttech.com

RUN apt-get update
RUN apt-get -y install curl gnupg

# Create app directory
WORKDIR /opt/

# Install app dependencies

COPY vsa-revamp-project/ ./

#open port
EXPOSE 3031/tcp

RUN curl -sL https://deb.nodesource.com/setup_18.x | bash
RUN apt-get -y install nodejs
RUN apt-get update
RUN apt-get install -y apt-utils
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p /usr/local/nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
ENV NODE_VERSION v18.12.1
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION && nvm use --delete-prefix $NODE_VERSION"


ENV NODE_PATH $NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

CMD npm start
