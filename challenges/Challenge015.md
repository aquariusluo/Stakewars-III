# Stake Wars: Episode III. Challenge 015
* Published on: 2022-08-30
* Updated on: 2022-08-30
* Submitted by: Viboracecata

Setup a kuutamo High Availability (HA) NEAR Validator running on `localnet` and `testnet`

The kuutamo (HA) NEAR Validator node distribution combines a Linux operating system (NixOS) preconfigured for security and performance for this use case, kuutamod, consuld and neard.

kuutamod is a distributed supervisor for neard that implements failover. To avoid having two active validators running simultaneously, kuutamod uses consul by acquiring a distributed lock.

kuutamod team is available for solving doubts about setting up kuutamod.
For support join [kuutamo-chat on Matrix.](https://matrix.to/#/#kuutamo-chat:kuutamo.chat) 

## Deliverables

1. Deploy kuutamod on a localnet
2. Deploy kuutamod on a testnet. 

## 1. Deploy kuutamod on a localnet
This guide shows how to deploy kuutamod along with neard on Hetzner VPS for localnet. The first step is creating NixOS 22.05. and then running a localnet cluster for testing on NixOS.

### 1.1 Create NixOS 22.05 on Hetzner VPS
#### CPX41 for Ubuntu20 in Falkenstein 
| Hardware       |        Standard                            |
| -------------- | ------------------------------------       |
| CPU            | 8v AMD                                     |
| RAM            | 16GB                                       |
| Storage        | 240GB SSD                                  |

#### Load ISO image of NixOS 22.05
![img](./images/Challenge015-1.png)
poweroff then poweron

#### Login from Hetzner console 
![img](./images/Challenge015-2.png)
#### Create password for root user
```
sudo passwd root
```
then login root user via ssh tools.

#### Check system disks
```
lsblk
NAME  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0   7:0    0 792.1M  1 loop 
sda     8:0    0 228.9G  0 disk 
sr0    11:0    1   824M  0 rom  /iso
```
#### Re-creating the partition.
```
parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MiB -8GiB
parted /dev/sda -- mkpart primary linux-swap -8GiB 100%

mkfs.ext4 -L nixos /dev/sda1
mkswap -L swap /dev/sda2

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2
nixos-generate-config --root /mnt
```
#### Modifiy the configuration to install NixOS
nano /mnt/etc/nixos/configuration.nix
```
nix.extraOptions = ''
  experimental-features = nix-command flakes
'';

boot.loader.grub.device = "/dev/sda";

networking.hostName = "my-validator";

services.openssh.enable = true;
```
#### Install NixOS
```
nixos-install 
```
#### Detach image of NixOS and reboot

#### Login from Hetzner console and create a user
```
useradd stakewar3 -d /home/stakewar3 -m
passwd stakewar3
chmod u+w /etc/sudoers
nano /etc/sudoers
    stakewar3 ALL=(ALL:ALL) SETENV: ALL
chmod u-w /etc/sudoers
```

## 2. Deploy kuutamod on a testnet
Login user "stakewar3" via ssh tool.
### Install requirements 
- [consul](https://www.consul.io/): This provides a distributed lock for
  kuutamod to detect liveness and prevent two validators from running at the
  same time.

- [neard](https://github.com/near/nearcore/releases/latest): Kuutamod will run this binary.

- [hivemind](https://github.com/DarthSim/hivemind): This is optionally required
  to run execute our [Procfile](../Procfile). You can also manually execute the
  commands contained in this file.

- [Python](https://www.python.org/) for some of the setup scripts.
Install the nix package manager (as described here), you can get all dependencies by running nix develop from the source directory of kuutamod:
```
su root
cd ~
nix-env -i git
git clone https://github.com/kuutamolabs/kuutamod
cd kuutamod
nix develop
```
![img](./images/Challenge015-3.png)

### After running nix develop or installing the dependencies, run the command hivemind:
```
hivemind
```
![img](./images/Challenge015-4.png)

### Open second ssh terminal to build and run first Near Validator Node
```
su root
cd ~/kuutamod
cargo build

nix-env -i jq
nix develop
./target/debug/kuutamod --neard-home .data/near/localnet/kuutamod0/ \
  --voter-node-key .data/near/localnet/kuutamod0/voter_node_key.json \
  --validator-node-key .data/near/localnet/node3/node_key.json \
  --validator-key .data/near/localnet/node3/validator_key.json \
  --near-boot-nodes $(jq -r .public_key < .data/near/localnet/node0/node_key.json)@127.0.0.1:33301
```
![img](./images/Challenge015-5.png)

### Open third ssh terminal to build and run second Near Voting Node
```
su root
cd ~/kuutamod
nix develop
./target/debug/kuutamod \
  --exporter-address 127.0.0.1:2234 \
  --validator-network-addr 0.0.0.0:24569 \
  --voter-network-addr 0.0.0.0:24570 \
  --neard-home .data/near/localnet/kuutamod1/ \
  --voter-node-key .data/near/localnet/kuutamod1/voter_node_key.json \
  --validator-node-key .data/near/localnet/node3/node_key.json \
  --validator-key .data/near/localnet/node3/validator_key.json \
  --near-boot-nodes $(jq -r .public_key < .data/near/localnet/node0/node_key.json)@127.0.0.1:33301
```
![img](./images/Challenge015-6.png)

### Open fourth ssh terminal to check Nodes status
#### Check first validating node status
curl http://localhost:2233/metrics
```
# HELP kuutamod_neard_restarts How often neard has been restarted
# TYPE kuutamod_neard_restarts counter
kuutamod_neard_restarts 1
# HELP kuutamod_state In what state our supervisor statemachine is
# TYPE kuutamod_state gauge
kuutamod_state{type="Registering"} 0
kuutamod_state{type="Shutdown"} 0
kuutamod_state{type="Startup"} 0
kuutamod_state{type="Syncing"} 0
kuutamod_state{type="Validating"} 1
kuutamod_state{type="Voting"} 0
# HELP kuutamod_uptime Time in milliseconds how long daemon is running
# TYPE kuutamod_uptime gauge
kuutamod_uptime 372272
```
The line kuutamod_state{type="Validating"} 1 indicates that kuutamod has set up neard as a validator, as you can also see from the neard home directory:
```
ls -la .data/near/localnet/kuutamod0/
drwxr-xr-x  3 root root 4096 Aug 30 10:02 .
drwxr-xr-x 10 root root 4096 Aug 30 09:34 ..
-rw-r--r--  1 root root 2253 Aug 30 10:02 config.json
drwxr-xr-x  2 root root 4096 Aug 30 10:02 data
-rw-r--r--  1 root root 6658 Aug 30 09:34 genesis.json
lrwxrwxrwx  1 root root   54 Aug 30 10:02 node_key.json -> /root/kuutamod/.data/near/localnet/node3/node_key.json
lrwxrwxrwx  1 root root   59 Aug 30 10:02 validator_key.json -> /root/kuutamod/.data/near/localnet/node3/validator_key.json
-rw-------  1 root root  214 Aug 30 09:34 voter_node_key.json
```
The validator key has been symlinked and the node key has been replaced with the node key specified in -validator-node-key
#### Check sencod voting node status
curl http://localhost:2234/metrics
```
# HELP kuutamod_state In what state our supervisor statemachine is
# TYPE kuutamod_state gauge
kuutamod_state{type="Registering"} 0
kuutamod_state{type="Shutdown"} 0
kuutamod_state{type="Startup"} 0
kuutamod_state{type="Syncing"} 0
kuutamod_state{type="Validating"} 0
kuutamod_state{type="Voting"} 1
# HELP kuutamod_uptime Time in milliseconds how long daemon is running
# TYPE kuutamod_uptime gauge
kuutamod_uptime 499732
```
If we look at its neard home directory we can also see that no validator key is present and the node key specified by --voter-node-key is symlinked:
```
ls -la .data/near/localnet/kuutamod1
drwxr-xr-x  3 root root 4096 Aug 30 09:57 .
drwxr-xr-x 10 root root 4096 Aug 30 09:34 ..
-rw-r--r--  1 root root 2253 Aug 30 09:57 config.json
drwxr-xr-x  2 root root 4096 Aug 30 09:57 data
-rw-r--r--  1 root root 6658 Aug 30 09:34 genesis.json
lrwxrwxrwx  1 root root   64 Aug 30 09:57 node_key.json -> /root/kuutamod/.data/near/localnet/kuutamod1/voter_node_key.json
-rw-------  1 root root  214 Aug 30 09:34 voter_node_key.json
```

## Update log

Updated 2022-08-30
