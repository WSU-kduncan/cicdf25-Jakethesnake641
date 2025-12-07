#!/bin/bash
docker stop dadjokes || true
docker rm dadjokes || true
docker pull jawing641/dadjokes:latest
docker run -d --name dadjokes --restart unless-stopped -p 80:80 jawing641/dadjokes:latest
