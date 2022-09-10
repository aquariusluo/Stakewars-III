# Stake Wars: Episode III. Challenge 020

- Published on: 2022-09-06
- Submitted by: Everstake
- Rewards: 0
- Deadline: Friday, September 9, 2022

**Note:** Participants will not receive rewards for this challenge. The  idea of this challenge is to provide additional training/practice for participants and prepare for running a mainnet validator. 

## Challenge submission

For submission, please fill out the [form](https://forms.gle/1MS9Jvhvq9YWbbwk7)

Please ensure to include your GitHub repo with the monitoring script in it in the **Proof of Completion: URLs** section 

Additionally, add a link to your Telegram channel with alerts in it to the **Proof of Completion: URLs** section. 

Optionally, you can add screenshots of your Telegram channel. 

## Acceptance Criteria

1. Create a monitoring tool for your node
2. Receive alerts to your channel using a telegram bot 

## 1. Monitor your node

Monitor the network by using NEAR's [JSON RPC APIs](https://docs.near.org/docs/interaction/rpc). Simple `curl` commands can extract valuable information for your validator operations, such as:

- current block height
- number of peers
- number of blocks `produced` vs `expected`
- validator status: current, next, and kicked out
- NEAR's node version and build, `new release` vs `node version`

## 2. Sending alerts using a telegram bot to a channel

Define the thresholds that trigger alerts, such as:

- node is stopped, zero new blocks downloaded
- a low number of peers, `<3`  (Additional task)
- missed blocks, risk of being kicked out, or insufficient stake
- a new nearcore build is running on the network (Additional task)

Example of sending a message:

```bash
curl -s -X POST https://api.telegram.org/bot${BOT_TOKEN}/sendMessage \
-d chat_id=${CHANNEL_ID} \
-d parse_mode="Markdown" \
-d text="*Validator name* %0A\${METRIC1}\\%0A\${METRIC2}\\%0A\${METRIC3}\\"
```

## How to Create Telegram Channel

- Click the **`menu`** button
- Select `**New Channel**` button
- Enter a channel name
- Click **`Create`**
- Select a channel type. You can make your channel **`Public`**
- Enter a link name
- Click **`SAVE`**

## How to Create Telegram bot

- Start a new conversation with the [BotFather](https://telegram.me/botfather)
- Send `/newbot` to create a new Telegram bot
- When asked, enter a name for the bot
- Give the Telegram bot a unique username. Note that the bot name must end with the word "`bot`" (case-insensitive)
- Copy and save the Telegram bot's access token for later steps

**Helpful link:**
[https://telegram.org/faq#q-how-do-i-create-a-bot](https://telegram.org/faq#q-how-do-i-create-a-bot)

## How to Add a Telegram Bot to Telegram Channel

- Open Channel menu
- Choose `Manage Channel`
- Choose `Administrators`
- Enter your bot's username and click `Add Administrator`
- In the next step, disable all permissions except `Post messages` and click `**Save**`

## Create monitoring shell tool


**Helpful link:**
[https://telegram.org/faq#q-can-i-assign-administrators](https://telegram.org/faq#q-can-i-assign-administrators)
