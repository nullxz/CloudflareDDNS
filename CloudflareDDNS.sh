#!/bin/bash
#####################################################################################
# zoneid You can find it on the Overview page. หาได้ในหน้า Overview
zoneid="" # เช่น 5b0acdf39f4069726d589f4069726d
name="" # เช่น dynamic.example.org
comment="" # comment ไม่ต้องใส่ก็ได้
# Auth API token ตัวอย่าง LlEyQZRx7cFfCy3ab6XLNw42ObnFbfYj
# Auth API token example LlEyQZRx7cFfCy3ab6XLNw42ObnFbfYj
auth=""
ttl="" # 300 = 5 minutes, 3600 = 1hour 
#####################################################################################
#
#
#
#
#
#
#
#
# FIND ID
zonedns=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$name" \
	-H "Authorization: Bearer $auth" \
	-H "Content-Type: application/json" | grep -Po '"id":"\K[^"]+')
## IP
data=$(curl -s https://api.cloudflare.com/cdn-cgi/trace | grep -Eo 'ip=[0-9.]+')
ip=$(echo $data | cut -d= -f2)
echo "The host IP is $ip"
## UPDATE DNS
curl --request PUT \
  --url https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$zonedns \
  --header 'Content-Type: application/json' \
  --header "Authorization: Bearer $auth" \
  --data "{
  \"content\": \"$ip\",
  \"name\": \"$name\",
  \"proxied\": false,
  \"type\": \"A\",
  \"comment\": \"$comment\",
  \"ttl\": $ttl
}"
