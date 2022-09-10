#!/bin/bash
  
# Refer to stakewar3 challenge20 https://github.com/near/stakewars-iii/blob/main/challenges/020.md
# sudo su
# Replace your CHANNEL_ID and BOT_TOKEN 
NEAR_ENV=shardnet
CHANNEL_ID=<@YOUR_CHANNEL_BOT>;
BOT_TOKEN=<YOUR_BOT_TOKEN>;

jsonstr_validator=$(curl -r -s -d '{"jsonrpc": "2.0", "method": "validators", "id": "dontcare", "params": [null]}' -H 'Content-Type: application/json' 127.0.0.1:3030 | jq -c '.result.current_validators[] | select(.account_id | contains ("viboracecata.factory.shardnet.near"))'  | json);
jsonstr_network=$(curl -r -s -d '{"jsonrpc": "2.0", "method": "network_info", "id": "dontcare", "params": [null]}' -H 'Content-Type: application/json' 127.0.0.1:3030 | json);

num_expected_blocks=$(echo $jsonstr_validator | jq -r ".num_expected_blocks");
num_produced_blocks=$(echo $jsonstr_validator | jq -r ".num_produced_blocks");
num_expected_chunks=$(echo $jsonstr_validator | jq -r ".num_expected_chunks");
num_produced_chunks=$(echo $jsonstr_validator | jq -r ".num_produced_chunks");
num_stake=$(echo $jsonstr_validator | jq -r ".stake");
num_stake=${num_stake:0:6};
num_active_peers=$(echo $jsonstr_network | jq -r ".result.num_active_peers");
seat_price=$(near validators current  | awk -F 'seat price:' '{print $2}' | tr -cd "[0-9]");
sync_state=$(curl -r -s -d '{"jsonrpc": "2.0", "method": "status", "id": "dontcare", "params": [null]}' -H 'Content-Type: application/json' 127.0.0.1:3030 |  jq -c '.result.sync_info.syncing' | json);

threshold_sync_state=true;
threshold_stake=10;
threshold_blocks=2;
threshold_chunks=2;
threshold_peers=5;

let diff_stake=$num_stake-$seat_price;
let diff_blocks=$num_expected_blocks-$num_produced_blocks;
let diff_chunks=$num_expected_chunks-$num_produced_chunks;

flag=$(echo "$diff_stake $threshold_stake $sync_state $threshold_sync_state $diff_blocks $threshold_blocks $diff_chunks $threshold_chunks $num_active_peers $threshold_peers" | \
        awk '{if (($1 < $2)||($3 == $4)||($5 > $6)||($7 > $8)||($9 < $10)) print 1; else print 0}');
if test $flag -eq 1;
then
        echo "bot alarm";
        curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage \
             -d chat_id=${CHANNEL_ID} \
             -d parse_mode="Markdown" \
             -d text="*<YOUR_POOL_ID>* %0A \
                *num_expected_chunks: *${num_expected_chunks} %0A \
                *num_produced_chunks: *${num_produced_chunks} %0A \
                *num_expected_blocks: *${num_expected_blocks} %0A \
                *num_produced_blocks: *${num_produced_blocks} %0A \
                *num_active_peers: *${num_active_peers} %0A \
                *seat_price: *${seat_price} %0A \
                *sync_state: *${sync_state} " ;
fi
