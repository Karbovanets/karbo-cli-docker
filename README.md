# Karbo masternode
Dockerized Karbo CLI environment for more convenient deployment. Can be used for:
  * deploying your own masternode
  * deploying simplewallet or walletd for your karbo-based services

## How to use
There are few ways you can run masternode:
  1. *(Not from this repo)* Install it on host. Less overhead solution, hard to maintain ([manual here](https://github.com/seredat/karbowanec/wiki/How-to-setup-KARBO-masternode))
  2. Run it from docker container. More overhead, less pain in maintenance
  3. Run it from docker container with Docker-compose. Most overhead solution, easiest maintenance (e.g. upgrades with two simple commands)

### Usage with Docker-compose

#### Installation
  1. Prepare environment ([link1](https://docs.docker.com/install/linux/docker-ce/ubuntu/), [link2](https://docs.docker.com/compose/install/))
  2. Clone that repository
  3. Edit .env file for setting your optimal preferences
  > Please pay attention to NODE_OWNER parameter. It is very useful if you can specify your email or messenger nickname so we can stay in touch with you, it's very useful in emergency cases such as hardforks and so on.

  4. *(Optional)* You can use a bootstrap for sync speedup. Use next command from repo home folder (where docker-compose.yml located): `wget https://bootstrap.karbo.io/latest.tar.gz -O ./data/node/latest.tar.gz && tar -xzvf ./data/node/latest.tar.gz -C ./data/node/ && rm ./data/node/latest.tar.gz`
  5. Run your node with next command: `docker-compose up -d karbo-node`

#### Usage
  * `docker-compose up -d karbo-node` - starts up node service
  * `docker-compose logs karbo-node` - shows log tty of the node
  * `docker-compose stop karbo-node` - stops the node

#### Maintenance
##### Get a newer node release
1. `docker-compose pull`
2. `docker-compose up -d karbo-node`

##### Set up cron for automatic update
1. `sudo crontab -e`
2. Add new command to your crontab: `cd *<path to your docker-compose.yml>* && docker-compose pull && docker-compose up -d karbo-node` with periodic you like (e.g. `@daily`)
3. Save it
4. `sudo /etc/init.d/cron reload`

### Usage with Docker

#### Installation
  1. Prepare environment ([link](https://docs.docker.com/install/linux/docker-ce/ubuntu/))
  2. Create a folder on your host for storing blockchain (e.g. /home/.karbo)
  3. Deploy your node with next command: `docker run -it --restart=always -p 32347:32347 -p 32348:32348 -v /home/.karbo:/home/karbo/.karbowanec --name=karbo-node -d karbovanets/karbo-cli --fee-address=*<your_wallet_address>*`
  4. Enjoy

#### Maintenance
##### Get a newer node release
  1. `docker pull karbovanets/karbo-cli`
  2. `docker stop karbo-node`
  3. `docker rm karbo-node`
  4. `docker run -it --restart=always -p 32347:32347 -p 32348:32348 -v /home/.karbo:/home/karbo/.karbowanec --name=karbo-node -d karbovanets/karbo-cli --fee-address=*<your_wallet_address>*`

# Credits
  1. [Looongcat](https://github.com/Looongcat) 2019
  2. If you're having some technical issues please feel free to visit our [tech chat](https://t.me/karbo_dev_lounge)
