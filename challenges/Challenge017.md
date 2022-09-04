# Near Validator on Akash
* Published on: 2022-08-16
* Updated on: 2022-08-26

* [Deploy Akash Docker](#deploy-akash-docker)
* [Setup Environment for Near](#setup-environment-for-near)
* [Deploy Validator Pool](#deploy-validator-pool)

## Description:
At this point we believe that all of you guys must have successfully deployed the chunk-only validator on one of the major cloud service providers like AWS.     
However, blockchain is  about decentralization,  we certainly don't want our infrastructures to be too centralized. Now lets try to deploy the validator with a decentralized cloud marketplace: [Akash](https://docs.akash.network/).
        
In this challenge, please try to create an account and deploy the chunk-only validator on Akash. In addition, to prove your work and also to pave the road for further developers, please record a video tutorial about how to deploy a validator on Akash step by step.

## Instructions:
- You may find this [guide](https://github.com/Dimokus88/near/blob/main/Guide_EN.md) created by Akash community helpful for you. But please deploy **testnet** rather than shardnet. 
- To get started with Akash, you can follow to this [doc](https://docs.akash.network/guides/cli/detailed-steps). Or join the discord server of Akash: http://discord.akash.network/
- If you need some Akash tokens to develop, please ask `Reason#9156` for help in NEAR stakewar discord channel.

## Deploy Akash Docker
### Install Akash CLI
Install Akash commands refer to the [guidebook](https://docs.akash.network/guides/cli/detailed-steps/part-1.-install-akash).

### Create/Recover an Account
```
tmux new-session -s node
tmux attach-session -t node

export AKASH_KEYRING_BACKEND=file
export AKASH_KEY_NAME=vibotest

akash keys add $AKASH_KEY_NAME
akash keys add $AKASH_KEY_NAME --recover

export AKASH_ACCOUNT_ADDRESS="$(akash keys show $AKASH_KEY_NAME -a)"

echo $AKASH_KEY_NAME 
echo $AKASH_ACCOUNT_ADDRESS
```

### Configure Akash Mainnet Network
- Setup shell variables
```
AKASH_NET="https://raw.githubusercontent.com/ovrclk/net/master/mainnet"
AKASH_VERSION="$(curl -s "$AKASH_NET/version.txt")"
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
export AKASH_GAS=auto
export AKASH_GAS_ADJUSTMENT=1.25
export AKASH_GAS_PRICES=0.025uakt
export AKASH_CHAIN_ID=akashnet-2
export AKASH_SIGN_MODE=amino-json

echo $AKASH_NODE $AKASH_CHAIN_ID $AKASH_KEYRING_BACKEND
```

- Check your Account Balance
```
akash query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS
````
- Create your Configuration for NEAR Docker named `near.yml`. but firstly generate a ssh key pair by following command:    
```
ssh-keygen -t rsa -f akash_docker_ssh_key -C root -b 2048
```

near.yml:    
```
---
version: "2.0"

services:
  app:
    image: ubuntu:20.04
    env:
     - 'SSH_PUBKEY=ssh-rsa AAAAB3NzaC1*************** root'
    command:
      - "bash"
      - "-c"
    args:
     - 'apt-get update;
     apt-get install -y --no-install-recommends -- ssh;
     mkdir -p -m0755 /run/sshd;
     mkdir -m700 ~/.ssh;
     echo "$SSH_PUBKEY" | tee ~/.ssh/authorized_keys;
     chmod 0600 ~/.ssh/authorized_keys;
     ls -lad ~ ~/.ssh ~/.ssh/authorized_keys;
     md5sum ~/.ssh/authorized_keys;
     exec /usr/sbin/sshd -D'
    expose:
      - port: 80
        as: 80
        to:
          - global: true
      - port: 22
        as: 22
        to:
          - global: true
      - port: 3030
        as: 3030
        to:
          - global: true
profiles:
  compute:
    app:
      resources:
        cpu:
          units: 4.0
        memory:
          size: 6Gi
        storage:
          size: 200Gi


  placement:
    akash:
      pricing:
        app:
          denom: uakt
          amount: 10000
deployment:
  app:
      resources:
        cpu:
          units: 4.0
        memory:
          size: 6Gi
        storage:
          size: 200Gi


  placement:
    akash:
      pricing:
        app:
          denom: uakt
          amount: 10000
deployment:
  app:
    akash:
      profile: app
      count: 1 
```      
    
- Create your Deployment.    
```
akash tx deployment create deploy.yml --from $AKASH_KEY_NAME 

export AKASH_DSEQ=<CHANGETHIS>
AKASH_OSEQ=1
AKASH_GSEQ=1

echo $AKASH_DSEQ $AKASH_OSEQ $AKASH_GSEQ
```

- View your Bids.   
```
akash query market bid list --owner=$AKASH_ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $AKASH_DSEQ --state=open

export AKASH_PROVIDER=<akash***>
echo $AKASH_PROVIDER
```

- Create and confirm a Lease.     
```
akash tx market lease create --dseq $AKASH_DSEQ --provider $AKASH_PROVIDER --from $AKASH_KEY_NAME

akash query market lease list --owner $AKASH_ACCOUNT_ADDRESS --node $AKASH_NODE --dseq $AKASH_DSEQ
> state: active
```

- Send the Manifest.     
```
akash provider send-manifest deploy.yml --dseq $AKASH_DSEQ --provider $AKASH_PROVIDER --from $AKASH_KEY_NAME
```
- Confirm the URL.    
```
akash provider lease-status --dseq $AKASH_DSEQ --from $AKASH_KEY_NAME --provider $AKASH_PROVIDER
```

- Update the Deployment.      
```
akash tx deployment update deploy.yml --dseq $AKASH_DSEQ --from $AKASH_KEY_NAME 
akash provider send-manifest deploy.yml --dseq $AKASH_DSEQ --provider $AKASH_PROVIDER --from $AKASH_KEY_NAME
```

- Close Deployment.       
```
akash tx deployment close --from $AKASH_KEY_NAME

unset AKASH_DSEQ AKASH_OSEQ AKASH_GSEQ
```


## Setup Environment for Near
- Installing Node.js and npm      
```
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -  
sudo apt install build-essential nodejs
PATH="$PATH"
```
- Install NEAR-CLI
```
sudo npm install -g near-cli
```

- Setup Network to "shardnet"
```
export NEAR_ENV=shardnet
echo 'export NEAR_ENV=testnet' >> ~/.bashrc
```

- Activate the node as validator.       
Install developer tools:
```
apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm curl tmux htop nano vim wget cargo 
```

- Clone nearcore project from GitHub First, clone the nearcore repository .
```
git clone https://github.com/near/nearcore
cd nearcore
git fetch
git checkout 1897d5144a7068e4c0d5764d8c9180563db2fe43
cargo build -p neard --release --features shardnet
```

- Initialize working directory.
```
./target/release/neard --home ~/.near init --chain-id shardnet --account-id=stakewar3_test.shardnet.near --download-genesis
cd ~/.near
rm config.json genesis.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
```

- Syncing to latest blocks height on Shardnet
```
/root/nearcore/target/release/neard run
```

__Note: Systemd cannot be used in Docker. We execute `neard` in `tmux`.__ 

## Deploy Validator Pool
Please refer to [step-by-step guide](https://github.com/crackerli/Stakewars-III/blob/master/challenges/Challenge005.md)

## Update log
Updated 2022-09-04:Creation
