#!/bin/sh
# dynamic-address.example.com
DNS=""
# 60 = 1m, 300 = 5m, 3600 = 1h
TTL=""
# My Home Server
COMMENT=""
# "4" OR "6" Only
IPv=""
# 764efa883dda1e11db47671c4a3bbd9e
ZONEID=""
# NzY0ZWZhODgzZGRhMWUxMWRiNDc2NzFjNGEzYmJkOWUK
TOKEN=""
# true OR false
PROXY="false"




# FIND ID
ZONEDNS=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records?type=A&name=$DNS" \
	-H "Authorization: Bearer $TOKEN" \
	-H "Content-Type: application/json" | grep -Po '"id":"\K[^"]+')

case $IPv in
	4)
		DATA=$(curl -s https://api.cloudflare.com/cdn-cgi/trace | awk -F= '/ip=([0-9.]+)/ {print $2}')
		TYPE="A"
	;;
	6)
		DATA=$(curl -s https://api.cloudflare.com/cdn-cgi/trace | awk -F= '/ip=([0-9a-fA-F:]+)/ {print $2}')
		TYPE="AAAA"
	;;
	*)
		echo "ERROR: Allow Only IPv4 OR IPv6"
		exit 1
	;;
esac

echo "The host IP is $DATA"

RESPONSE=$(curl -s --request PUT \
  --url https://api.cloudflare.com/client/v4/zones/$ZONEID/dns_records/$ZONEDNS \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $TOKEN" \
  --data "{
  \"content\": \"$DATA\",
  \"name\": \"$DNS\",
  \"proxied\": $PROXY,
  \"type\": \"$TYPE\",
  \"comment\": \"$COMMENT\",
  \"ttl\": $TTL
}")

SUCCESS=$(echo "$RESPONSE" | grep -o '"success":true')
if [ "$SUCCESS" = "\"success\":true" ]; then
	echo "$RESPONSE"
	echo "[ OK ]"
else
	echo "$RESPONSE"
	echo "[ FAIL ] BAD AUTH OR ZONEID"
fi
