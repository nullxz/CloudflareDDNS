#!/bin/bash
#####################################################################################
# zoneid You can find it on the Overview page. หาได้ในหน้า Overview
# DNS "A" Only / IPv4
ZONEID="" # เช่น 5b0acdf39f4069726d589f4069726d
DNS="" # เช่น dynamic.example.org
COMMENT="" # comment ไม่ต้องใส่ก็ได้
AUTH="" # Auth API token example V1NQQ1VoYTBaMDJGXzA0cUthS290NW5rdlJleW40bHUK ตัวอย่าง V1NQQ1VoYTBaMDJGXzA0cUthS290NW5rdlJleW40bHUK
TTL="" # 300 = 5 minutes, 3600 = 1hour
PROXY="false" # false / true
#####################################################################################
echo "========================================================"
date -R
# FIND ID
ZONEDNS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records?type=A&name=$DNS" \
	-H "Authorization: Bearer $AUTH" \
	-H "Content-Type: application/json" | grep -Po '"id":"\K[^"]+')
## IP
DATA=$(curl -s https://api.cloudflare.com/cdn-cgi/trace | grep -Eo 'ip=[0-9.]+')
IP=$(echo $DATA | cut -d= -f2)
echo "The host IP is $IP"
## UPDATE DNS
RESPONSE=$(curl -s --request PUT \
  --url https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$ZONEDNS \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $AUTH" \
  --data "{
  \"content\": \"$IP\",
  \"name\": \"$DNS\",
  \"proxied\": $PROXY,
  \"type\": \"A\",
  \"comment\": \"$COMMENT\",
  \"ttl\": $TTL
}")
SUCCESS=$(echo "$RESPONSE" | grep -o '"success":true')
if [[ "$SUCCESS" == "\"success\":true" ]]; then
  echo "$RESPONSE"
  echo "[ OK ]"
  echo "========================================================"

else
  echo "[ fail ] BAD AUTH or ZONEID"
  echo "========================================================"
fi
