#!/bin/bash

echo "===== LMS 502 HEALTH CHECK ====="
date

echo
echo "===== DOCKER STATUS ====="
docker ps -a

echo
echo "===== LMS ENDPOINT TEST ====="
for i in {1..20}; do
    echo "Request $i"
    curl -s -o /dev/null \
      -w "HTTP %{http_code} | Time %{time_total}s\n" \
      http://local.openedx.io
done

echo
echo "===== CADDY TO LMS ====="
docker exec tutor_local-caddy-1 curl -I http://lms:8000

echo
echo "===== RESOURCE STATUS ====="
free -h
df -h

echo
echo "===== CONTAINER RESTART CHECK ====="
for c in tutor_local-caddy-1 tutor_local-lms-1 tutor_local-mysql-1; do
    docker inspect -f \
    'Status={{.State.Status}} RestartCount={{.RestartCount}} StartedAt={{.State.StartedAt}}' \
    "$c"
done
