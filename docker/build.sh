#!/usr/bin/env bash

sudo rm ./logs/access.log
sudo rm ./logs/error.log

docker build -t rossedlin/exeter:5.3c .