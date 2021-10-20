FROM debian:10-slim
LABEL description="Karbo CLI image"
LABEL repository="https://github.com/Karbovanets/karbo-cli-docker"
LABEL helpdesk="https://t.me/karbo_dev_lounge"

# change CLI version here to upgrade the image
ENV CLI_VERSION 1.8.3

# Dependencies installation
RUN apt-get update && apt-get install -y wget

# add restricted user for running node
RUN /bin/bash -c 'adduser --disabled-password --gecos "" karbo'

# Deploy needed version of Karbo CLI
WORKDIR /home/karbo

RUN wget -q https://github.com/seredat/karbowanec/releases/download/v.$CLI_VERSION\/Karbo-cli-ubuntu18.04-v.$CLI_VERSION.tar.gz &&\
	tar -xzvf Karbo-cli-ubuntu18.04-v.$CLI_VERSION.tar.gz &&\
	mv ./karbowanecd /usr/bin/karbowanecd &&\
	mv ./walletd /usr/bin/walletd &&\
	mv ./simplewallet /usr/bin/simplewallet &&\
	mv ./greenwallet /usr/bin/greenwallet &&\
	mv ./optimizer /usr/bin/optimizer &&\
	rm -rf ./* &&\
	chmod +x /usr/bin/karbowanecd /usr/bin/walletd /usr/bin/simplewallet /usr/bin/greenwallet /usr/bin/optimizer

# Create blockchain folder and assign owner to the files
RUN /bin/bash -c 'mkdir /home/karbo/.karbowanec'
RUN /bin/bash -c 'chown karbo:karbo /home/karbo/.karbowanec /usr/bin/karbowanecd /usr/bin/simplewallet /usr/bin/walletd /usr/bin/greenwallet /usr/bin/optimizer '

# Open container's ports for P2P and Lightwallet connections
EXPOSE 32347/tcp 32348/tcp

# Define blockchain volume
VOLUME ["/home/karbo/.karbowanec"]

# Default options for node
CMD ["--fee-address=Kdev1L9V5ow3cdKNqDpLcFFxZCqu5W2GE9xMKewsB2pUXWxcXvJaUWHcSrHuZw91eYfQFzRtGfTemReSSMN4kE445i6Etb3", "--fee-amount=0.1"]

# Default entrypoint, can be redefined if you need wallet
ENTRYPOINT ["karbowanecd", "--data-dir=/home/karbo/.karbowanec", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=32348"]
