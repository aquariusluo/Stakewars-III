# Stake Wars: Episode III. Challenge 013
* Published on: 2022-09-01
* Updated on: 2022-09-01
* Submitted by: Viboracecata

This guide demostrates how to update nodes, migrate keys, and set up a BACKUP node.

## Deliverables

1. Create backup VPS on Hetzner
2. Build and config backup node
3. Migrate validator from main node to backup node

## 1. Create backup VPS on Hetzner
### Deploy CPX41 on Hetzner
| Hardware       |        Standard                            |
| -------------- | ------------------------------------       |
| CPU            | 8v AMD                                     |
| RAM            | 16GB                                       |
| Storage        | 240GB SSD                                  |

### Create user of stakewar3
```
useradd stakewar3 -d /home/stakewar3 -m
passwd stakewar3
chmod u+w /etc/sudoers
vi /etc/sudoers
   stakewar3 ALL=(ALL:ALL) ALL
chmod u-w /etc/sudoers
vi /etc/passwd
  stakewar3:x:1000:1000::/home/stakewar3:/bin/bash
```
### Enable firewall for NEAR and Hetzner
```
sudo ufw allow 22
sudo ufw allow 24567
sudo ufw deny out from any to 10.0.0.0/8
sudo ufw deny out from any to 172.16.0.0/12
sudo ufw deny out from any to 192.168.0.0/16
sudo ufw deny out from any to 100.64.0.0/10
sudo ufw deny out from any to 169.254.0.0/16
sudo ufw enable
sudo ufw status
```
### Setup environment
```
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -  
sudo apt install build-essential nodejs
PATH="$PATH"

sudo npm install -g near-cli

export NEAR_ENV=shardnet
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc

sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo

sudo apt install python3-pip

USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"

sudo apt install clang build-essential make

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
```

## 2. Build and config backup node

Clone nearcore project from GitHub. First, clone the nearcore [repository](https://github.com/near/nearcore) .  
```
git clone https://github.com/near/nearcore
cd nearcore
git fetch
```
Checkout to the commit needed. Please refer to the commit defined in [this file](https://github.com/near/stakewars-iii/blob/main/commit.md) .
```
git checkout <commit>
```
Compile nearcore binary
In the nearcore folder run the following commands:
```
cargo build -p neard --release --features shardnet
```
Initialize working directory
```
./target/release/neard --home ~/.near/shardnet init --chain-id shardnet --download-genesis
```
Replace the config.json and genesis.json
```
cd ~/.near/shardnet
rm ./config.json ./genesis.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
```

* Generate the validator_key.json by __near generate-key <pool_id>__   
For example: Set <pool_id> as _viboracecata_backup.factory.shardnet.near_
```
near generate-key viboracecata_backup.factory.shardnet.near
```


## 3. Migrate validator from main node to backup node

//TODO - Description of the challenge

## Update log

Updated 2022-09-01

