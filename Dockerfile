FROM debian:9-slim
LABEL description="Karbo CLI image"
LABEL repository="https://github.com/Karbovanets/karbo-cli-docker"
LABEL helpdesk="https://t.me/karbo_dev_lounge"

# change CLI version here to upgrade the image
ENV CLI_VERSION="1.6.6"

# Dependencies installation
RUN apt-get update && apt-get install -y wget

# add restricted user for running node
RUN /bin/bash -c 'adduser --disabled-password --gecos "" karbo'

# Deploy needed version of Karbo CLI
WORKDIR /home/karbo
RUN wget -q https://github.com/seredat/karbowanec/releases/download/v.$CLI_VERSION/karbowanec-trusty-$CLI_VERSION\_linux_x86_64.tar.gz &&\
	tar -xzvf karbowanec-trusty-$CLI_VERSION\_linux_x86_64.tar.gz &&\
	mv ./karbowanec-trusty-$CLI_VERSION\_linux_x86_64/karbowanecd /usr/bin/karbowanecd &&\
	mv ./karbowanec-trusty-$CLI_VERSION\_linux_x86_64/walletd /usr/bin/walletd &&\
	mv ./karbowanec-trusty-$CLI_VERSION\_linux_x86_64/simplewallet /usr/bin/simplewallet &&\
	mv ./karbowanec-trusty-$CLI_VERSION\_linux_x86_64/greenwallet /usr/bin/greenwallet &&\
	rm -rf ./* &&\
	chmod +x /usr/bin/karbowanecd /usr/bin/walletd /usr/bin/simplewallet /usr/bin/greenwallet

# Create blockchain folder and assign owner to the files
RUN /bin/bash -c 'mkdir /home/karbo/.karbowanec'
RUN /bin/bash -c 'chown karbo:karbo /home/karbo/.karbowanec /usr/bin/karbowanecd /usr/bin/simplewallet /usr/bin/walletd /usr/bin/greenwallet '

# Open container's ports for P2P and Lightwallet connections
EXPOSE 32347/tcp 32348/tcp

# Define blockchain volume
VOLUME ["/home/karbo/.karbowanec"]

# Default options for node
CMD ["--fee-address=Kdev1L9V5ow3cdKNqDpLcFFxZCqu5W2GE9xMKewsB2pUXWxcXvJaUWHcSrHuZw91eYfQFzRtGfTemReSSMN4kE445i6Etb3"]

# Default entrypoint, can be redefined if you need wallet
ENTRYPOINT ["karbowanecd", "--data-dir=/home/karbo/.karbowanec", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--rpc-bind-port=32348"]
