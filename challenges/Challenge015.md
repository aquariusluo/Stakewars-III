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
| IP             | 49.12.209.74                               |

Load ISO image of NixOS 22.05




## 2. Deploy kuutamod on a testnet

//TODO - Description of the challenge


## Update log

Updated 2022-08-30
