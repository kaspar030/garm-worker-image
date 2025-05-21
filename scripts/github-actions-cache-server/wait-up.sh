#!/bin/sh

for i in $(seq 20); do
	curl http://localhost:3000 -fso /dev/null && exit
done

echo "timeout reached, continuing anyways"
