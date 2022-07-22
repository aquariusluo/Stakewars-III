# Stake Wars: Episode III. Challenge 005
* Published on: 2022-07-22
* Updated on: 2022-07-22
* Submitted by: Viboracecata

💡 __This is a step-by-step guide on how to mount a node validator for Stake Wars III challenge 005.__     


* [Create your Shardnet wallet](#create-your-shardnet-wallet)
    - [Input a wallet name](#input-a-wallet-name)
    - [Save the secure passphrase](#save-the-secure-passphrase)
    - [Verify passphrase](#verify-passphrase)
* [Setup a validator and sync it to the actual state of the network](#setup-a-validator-and-sync-it-to-the-actual-state-of-the-network)
    - [Create AWS EC2 instance with princing](#create-aws-ec2-instance-with-princing)
    - [Setup ubuntu desktop](#setup-ubuntu-desktop)
    - [Setup environment](setup-environment)
    - [Authorize wallet locally](#authorize-wallet-locally)
* [Deploy a new staking pool for your validator](#deploy-a-new-staking-pool-for-your-validator)
* [Setup tools for monitoring node status](#setup-tools-for-monitoring-node-status)


## Create your Shardnet wallet  
### Input a wallet name
Access to https://wallet.shardnet.near.org/create and input account ID: `mywallet0` 
<figure class="third">
    <img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-0.png" width="500"/><img src="https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/wallet-1.png" width="400"/>
</figure>

### Save the secure passphrase
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
### Create AWS EC2 instance with princing
Access to AWS console https://aws.amazon.com/console/ and create C5.xlarge instance. The price per month is $146 in N.V US.  
        
C5.xlarge | Spec           
----------:|------------
CPU      |  4 Core
Memory   |  8 G 
SSD      |  200 G
OS       |  Ubuntu 20.04
Price    |  $146           

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


## Deploy a new staking pool for your validator
## Setup tools for monitoring node status

## Update log
Updated 2022-07-22:Creation
