# CloudflareDDNS
#### EN
>#### Requires curl grep awk sh crontab
>#### You must first create an empty Record in the Cloudflare dashboard
>like `test.example.com  300	IN	A	0.0.0.0`
>#### IPv4 OR IPv6
>
>Create DDNS using Cloudflare API
>
>It should be used with crontab.
>
> `* * * * * /home/USER/cloudflareddns.sh >/dev/null 2>&1`

#### TH
>#### ต้องมี curl grep awk sh crontab
>#### ต้องสร้าง Record เปล่าใน Cloudflare dashboard ก่อน
>เช่น `test.example.com  300	IN	A	0.0.0.0`
>#### IPv4 หรือ IPv6
> สร้าง DDNS โดยใช้ Cloudflare API
> 
> ควรใช้คู่กับ crontab
>
> แก้ไขไฟล์ก่อนใช้ด้วย
>
> ตัวอย่าง
>
> `* * * * * /home/USER/cloudflareddns.sh >/dev/null 2>&1`

