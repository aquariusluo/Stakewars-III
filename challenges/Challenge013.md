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

## 2. Build and config backup node

//TODO - Description of the challenge

## 3. Migrate validator from main node to backup node

//TODO - Description of the challenge

## Update log

Updated 2022-09-01

