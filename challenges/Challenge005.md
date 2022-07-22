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
    - [Create an EC2 instance on AWS](#create-an-EC2-instance-on-aws)
    - [Setup ubuntu desktop](#setup-ubuntu-desktop)
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
### Create an EC2 instance on AWS
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

## Deploy a new staking pool for your validator
## Setup tools for monitoring node status

## Update log
Updated 2022-07-22:Creation
