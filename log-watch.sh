#!/bin/bash

# 検出対象ログファイル
WATCH=${WATCH:-/target}
# 検出文字列
CONDITION_TO_NOTIFY=${CONDITION_TO_NOTIFY:-"error"}
SLACK_INCOMMING_WEBHOOK_URL=${SLACK_INCOMMING_WEBHOOK_URL:-""}
SLACK_NOTIFICATION_TITLE=${SLACK_NOTIFICATION_TITLE:-"ERROR OCCURRED"}

function notify() {
    while read matched_log_line
    do
      echo ${matched_log_line}
      if [ ! -z "${SLACK_INCOMMING_WEBHOOK_URL}" ]; then
        curl --silent --show-error \
          --request POST \
          --header 'Content-type: application/json' \
          --data '{"text":"", "attachments":[{"color":"#FBC02D", "title": "'"$(escape "${SLACK_NOTIFICATION_TITLE}")"'", "text": "'"$(escape "${matched_log_line}")"'"}]}' \
          "${SLACK_INCOMMING_WEBHOOK_URL}"
      fi
    done
}

function escape() {
  echo "$1" | sed -r 's/"/\\"/g'
}

tail --lines=0 --follow=name --retry ${WATCH} \
  | grep --line-buffered --extended-regexp "${CONDITION_TO_NOTIFY}" \
  | notify
