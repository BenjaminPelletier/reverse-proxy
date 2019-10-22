#!/bin/bash
echo === `date` ===
docker container exec -i reverseproxy certbot renew
echo
