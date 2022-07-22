# Stake Wars: Episode III. Challenge 005
* Published on: 2022-07-22
* Updated on: 2022-07-22
* Submitted by: Viboracecata

💡 __This is a step-by-step guide on how to mount a node validator for Stake Wars III challenge 005.__     


* [Create your Shardnet wallet](#create-your-shardnet-wallet)
    - [Input a wallet name](#input-a-wallet-name)
    - [Save secure passphrase](#save-secure-passphrase)
    - [Verify passphrase](#verify-passphrase)
* [Setup a validator and sync it to the actual state of the network](#setup-a-validator-and-sync-it-to-the-actual-state-of-the-network)
    - [Create AWS EC2 instance](#create-aws-ec2-instance)
    - [Setup ubuntu desktop](#setup-ubuntu-desktop)
    - [Setup environment](setup-environment)
    - [Authorize wallet locally](#authorize-wallet-locally)
    - [Activate the node as validator](#activate-the-node-as-validator)
* [Deploy a new staking pool for your validator](#deploy-a-new-staking-pool-for-your-validator)
    - [Useful links](#useful-links)
    - [Deploy a Staking Pool Contract](#deploy-a-staking-pool-contract)
    - [Transactions Guide](#transactions-guide)
* [Setup tools for monitoring node status](#setup-tools-for-monitoring-node-status)
* [AWS EC2 pricing per month](#aws-ec2-pricing-per-month)


## Create your Shardnet wallet  
### Input a wallet name
Access to https://wallet.shardnet.near.org/create and input account ID: `mywallet0` 
<figure class="third">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-0.png" width="500"/><img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-1.png" width="400"/>
</figure>

### Save secure passphrase
<figure class="third">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-2.png" width="400"/><img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-3.png" width="400"/>
</figure>
Please save 12 passphase words safely, which will be used to restore your account.    

### Verify passphrase
<figure class="third">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-4.png" width="400"/><img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-5.png" width="400"/>
</figure>
Return to main wallet UI.   
<figure class="third">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-7.png" width="400"/>
</figure>
Now, You have a wallet named "mywallet0.shardnet.near" with 560 faucets.

## Setup a validator and sync it to the actual state of the network
*_This section is focused on deploying a node (nearcore), downloading a snapshot, syncing it to the actual state of the network._*  
### Create AWS EC2 instance
Access to AWS console https://aws.amazon.com/console/ and create C5.xlarge instance.  
        
C5.xlarge | Spec           
----------:|------------
CPU      |  4 Core
Memory   |  8 G 
SSD      |  200 G
OS       |  Ubuntu 20.04        

<center class="half">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-1.png" width="1000"/>
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-2.png" width="800"/>
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-3.png" width="800"/>
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-4.png" width="800"/>
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-5.png" width="800"/>
</center>

### Setup ubuntu desktop
* Create root user "stakewar3"
```bash
sudo useradd stakewar3 -d /home/stakewar3 -m
sudo passwd stakewar3
sudo chmod u+w /etc/sudoers
sudo vi /etc/sudoers
#Add a line below root ALL=(ALL:ALL) ALL 
  stakewar3 ALL=(ALL:ALL) ALL
sudo chmod u-w /etc/sudoers
sudo vi /etc/passwd
#Modify the line below
  "stakewar3:x:1000:1000::/home/stakewar3:/bin/sh" 
 To 
  "stakewar3:x:1000:1000::/home/stakewar3:/bin/bash"
su stakewar3
```
* Setup "ubuntu-desktop"
```bash
sudo apt-get update
sudo apt-get upgrade
sudo vi /etc/ssh/sshd_config
PasswordAuthentication yes
sudo /etc/init.d/ssh restart

export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get update
sudo -E apt-get install -y ubuntu-desktop
sudo apt-get install xfce4 xrdp
sudo apt-get install xfce4 xfce4-goodies
echo xfce4-session > ~/.xsession
sudo cp ~/.xsession /etc/skel
sudo service xrdp restart
```
* Launch APP of "Remote Desktop Connection" to verify ubuntu-desktop.

### Setup environment
*  Installing Node.js and npm
```bash
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -  
sudo apt install build-essential nodejs
PATH="$PATH"
```
```
node -v
```
> v18.x.x
```
npm -v
```
> 8.x.x

* Install NEAR-CLI
```base
sudo npm install -g near-cli
```
* Setup Network to "Shardnet"
```bash
export NEAR_ENV=shardnet
echo 'export NEAR_ENV=shardnet' >> ~/.bashrc
```
* NEAR CLI Commands Guide:

```
near proposals
```
A proposal by a validator indicates they would like to enter the validator set, in order for a proposal to be accepted it must meet the minimum seat price.

```
near validators current
```
This shows a list of active validators in the current epoch, the number of blocks produced, number of blocks expected, and online rate. Used to monitor if a validator is having issues.
```
near validators next
```
This shows validators whose proposal was accepted one epoch ago, and that will enter the validator set in the next epoch.

### Authorize wallet locally
* Access to ubuntu desktop via "Remote Desktop Connection" by user "stakewar3" and your passwords.
* Execute: `near login`

<center class="half">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-6.png" width="600"/>
</center>

* Import the account by passphrase
<center class="half">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-7.png" width="600"/>
</center>

* Check credentials files
```
ls ~/.near-credentials/shardnet
```
> mywallet0.shardnet.near.json

### Activate the node as validator
* Confirm that your machine has the right CPU features
```bash
lscpu | grep -P '(?=.*avx )(?=.*sse4.2 )(?=.*cx16 )(?=.*popcnt )' > /dev/null \
  && echo "Supported" \
  || echo "Not supported"
```
> Supported
* Install developer tools:
```
sudo apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo
```
* Install Python pip:
```
sudo apt install python3-pip
```
* Set the configuration:
```
USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"
```
* Install Building env
```
sudo apt install clang build-essential make
```
* Install Rust & Cargo
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
![image](https://github.com/near/stakewars-iii/raw/main/challenges/images/rust.png)    

Press 1 and press enter.
Source the environment
```
source $HOME/.cargo/env
```
* Clone nearcore project from GitHub
First, clone the nearcore [repository](https://github.com/near/nearcore) .
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
> The binary path is target/release/neard.  

Initialize working directory
```
./target/release/neard --home ~/.near init --chain-id shardnet --download-genesis
```
> This command will create the directory of *~/.near* and will generate config.json, node_key.json, and genesis.json  

Replace the config.json
```
rm ~/.near/config.json
wget -O ~/.near/config.json https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/config.json
```
* Get latest snapshot
Install AWS Cli  
```
sudo apt-get install awscli -y
```
Download snapshot (genesis.json)   
```
cd ~/.near
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/shardnet/genesis.json
```
If the above fails, AWS CLI may be oudated in your distribution repository. Instead, try:
```
pip3 install awscli --upgrade
```
* Generate the validator_key.json by __near generate-key <pool_id>__   
For example: Set <pool_id> as _stakewar3pool.factory.shardnet.near_
```
near generate-key stakewar3pool.factory.shardnet.near
```
* Copy the file generated to shardnet folder: Make sure to replace <pool_id> by your accountId.   
cp ~/.near-credentials/shardnet/YOUR_WALLET.json ~/.near/validator_key.json
```
cp ~/.near-credentials/shardnet/mywallet0.shardnet.near.json ~/.near/validator_key.json
vi ~/.near/validator_key.json
```
> Edit “account_id” => stakewar3pool.factory.shardnet.near   
> Change private_key to secret_key

```
{
  "account_id": "stakewar3pool.factory.shardnet.near",
  "public_key": "ed25519:5ZHEUwpHYFHQ88CNh1TPcZ1LcwaHaSSsBLWwRaGhi3AF",
  "secret_key": "ed25519:****"
}
```
* Setup Systemd Command:   
```
sudo vi /etc/systemd/system/neard.service
```
Paste:   
```
[Unit]
Description=NEARd Daemon Service

[Service]
Type=simple
User=stakewar3
#Group=near
WorkingDirectory=/home/stakewar3/.near
ExecStart=/home/stakewar3/nearcore/target/release/neard run
Restart=on-failure
RestartSec=30
KillSignal=SIGINT
TimeoutStopSec=45
KillMode=mixed

[Install]
WantedBy=multi-user.target
```
Enable autoexecution and start service
```
sudo chmod 755 /etc/systemd/system/neard.service
sudo systemctl daemon-reload
sudo systemctl enable neard
sudo systemctl start neard
```
Watch logs:   
```
journalctl -n 100 -f -u neard
```  

## Deploy a new staking pool for your validator
_Deploy a new staking pool for your validator. Do operations on your staking pool to delegate and stake NEAR._     

### Useful links
Wallet: https://wallet.shardnet.near.org/     
Explorer: https://explorer.shardnet.near.org/ 

### Deploy a Staking Pool Contract
Calls the staking pool factory, creates a new staking pool with the specified name, and deploys it to the indicated accountId.   
```
near call factory.shardnet.near create_staking_pool '{"staking_pool_id": "<pool id>", "owner_id": "<accountId>", "stake_public_key": "<public key>", "reward_fee_fraction": {"numerator": 5, "denominator": 100}, "code_hash":"DD428g9eqLL8fWUxv8QSpVFzyHi1Qd16P8ephYCTmMSZ"}' --accountId="<accountId>" --amount=30 --gas=300000000000000
```
From the example above, you need to replace:

* **Pool ID**: Staking pool name, the factory automatically adds its name to this parameter, creating {pool_id}.{staking_pool_factory}
Examples:   

- If pool id is stakewars will create : `stakewar3pool.factory.shardnet.near`

* **Owner ID**: The SHARDNET account (i.e. mywallet0.shardnet.near) that will manage the staking pool.
* **Public Key**: The public key in your **validator_key.json** file.
* **5**: The fee the pool will charge (e.g. in this case 5 over 100 is 5% of fees).
* **Account Id**: The SHARDNET account deploying and signing the mount tx.  Usually the same as the Owner ID.(e.g. mywallet0.shardnet.near)

> Be sure to have at least 30 NEAR available, it is the minimum required for storage.
Example : near call stakewar3pool.factory.shardnet.near --amount 30 --accountId stakewars.shardnet.near --gas=300000000000000

In this case, 500 tokens are initially seldelegated.
```
near call factory.shardnet.near create_staking_pool '{"staking_pool_id": "stakewar3pool", "owner_id": "mywallet0.shardnet.near", "stake_public_key": "ed25519:5ZHEUwpHYFHQ88CNh1TPcZ1LcwaHaSSsBLWwRaGhi3AF", "reward_fee_fraction": {"numerator": 5, "denominator": 100}, "code_hash":"DD428g9eqLL8fWUxv8QSpVFzyHi1Qd16P8ephYCTmMSZ"}' --accountId="mywallet0.shardnet.near" --amount=500 --gas=300000000000000
```
To change the pool parameters, such as changing the amount of commission charged to 1% in the example below, use this command:   
```
near call stakewar3pool.factory.shardnet.near update_reward_fee_fraction '{"reward_fee_fraction": {"numerator": 1, "denominator": 100}}' --accountId mywallet0.shardnet.near --gas=300000000000000
```
**You have now configure your Staking pool.**

Check your pool is now visible on https://explorer.shardnet.near.org/nodes/validators    
Or, Check via command below, If you see the screenshot, you're good to be validator producting blocks.
```
journalctl -n 1000 -f -u neard
```
![image](https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/val-9.png)


### Transactions Guide
#### Deposit and Stake NEAR

Command:
```
near call <staking_pool_id> deposit_and_stake --amount <amount> --accountId <accountId> --gas=300000000000000
```
#### Unstake NEAR
Amount in yoctoNEAR.

Run the following command to unstake:
```
near call <staking_pool_id> unstake '{"amount": "<amount yoctoNEAR>"}' --accountId <accountId> --gas=300000000000000
```
To unstake all you can run this one:
```
near call <staking_pool_id> unstake_all --accountId <accountId> --gas=300000000000000
```
#### Withdraw

Unstaking takes 2-3 epochs to complete, after that period you can withdraw in YoctoNEAR from pool.

Command:
```
near call <staking_pool_id> withdraw '{"amount": "<amount yoctoNEAR>"}' --accountId <accountId> --gas=300000000000000
```
Command to withdraw all:
```
near call <staking_pool_id> withdraw_all --accountId <accountId> --gas=300000000000000
```

#### Ping
A ping issues a new proposal and updates the staking balances for your delegators. A ping should be issued each epoch to keep reported rewards current.

Command:
```
near call <staking_pool_id> ping '{}' --accountId <accountId> --gas=300000000000000
```
Balances
Total Balance
Command:
```
near view <staking_pool_id> get_account_total_balance '{"account_id": "<accountId>"}'
```
#### Staked Balance
Command:
```
near view <staking_pool_id> get_account_staked_balance '{"account_id": "<accountId>"}'
```
#### Unstaked Balance
Command:
```
near view <staking_pool_id> get_account_unstaked_balance '{"account_id": "<accountId>"}'
```
#### Available for Withdrawal
You can only withdraw funds from a contract if they are unlocked.

Command:
```
near view <staking_pool_id> is_account_unstaked_balance_available '{"account_id": "<accountId>"}'
```
#### Pause / Resume Staking
##### Pause
Command:
```
near call <staking_pool_id> pause_staking '{}' --accountId <accountId>
```
##### Resume
Command:
```
near call <staking_pool_id> resume_staking '{}' --accountId <accountId>
```

## Setup tools for monitoring node status


## AWS EC2 pricing per month
The price of EC2 instance c5.xlarge is $146 per month in N.V US.

EC2       | Storage   | Sum
---------:|----------:|-------
 c5.xlarge| 200 G SSD |
 $126     | $20       |$146

 
## Update log
Updated 2022-07-22:Creation
