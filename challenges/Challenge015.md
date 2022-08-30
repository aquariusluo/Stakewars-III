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
| IP             | 142.132.178.12                               |

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
#### unload image of NixOS and reboot

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

//TODO - Description of the challenge


## Update log

Updated 2022-08-30
