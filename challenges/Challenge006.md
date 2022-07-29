# Stake Wars: Episode III. Challenge 006
* Published on: 2022-07-29
* Updated on: 2022-07-29
* Submitted by: viboracecata

Create a cron task on the machine running node validator that allows ping to network automatically.

## Steps

Create a new file on /home/stakewar3/scripts/ping.sh

```
#!/bin/sh
# Ping call to renew Proposal added to crontab

export NEAR_ENV=shardnet
export LOGS=/home/stakewar3/logs
export POOLID=viboracecata
export ACCOUNTID=viboracecata

echo "---" >> $LOGS/all.log
date >> $LOGS/all.log
near call $POOLID.factory.shardnet.near ping '{}' --accountId $ACCOUNTID.shardnet.near --gas=300000000000000 >> $LOGS/all.log
near proposals | grep $POOLID >> $LOGS/all.log
near validators current | grep $POOLID >> $LOGS/all.log
near validators next | grep $POOLID >> $LOGS/all.log

```
Create a new crontab, running every 5 minutes:

```
crontab -e
*/5 * * * * sh /home/<USER_ID>/scripts/ping.sh
```

List crontab to see it is running:
```
crontab -l
```

Review your logs 

```
cat /home/stakewar3/logs/all.log
```
Screenshot of pool transactions
![image](https://github.com/aquariusluo/Stakewars-III/blob/main/challenges/images/challenge006.png)

## Update log


Updated 2022-07-29: Creation

