docker run \
  --log-driver json-file \
  --log-opt max-size=10m \
  --log-opt max-file=10 \
  --name reverseproxy \
  --restart always \
  -v ~/reverseproxy/conf:/etc/nginx/conf.d \
  -v ~/reverseproxy/letsencrypt:/etc/letsencrypt \
  -p 80:80 -p 443:443 -d benpelletier/reverse_proxy
