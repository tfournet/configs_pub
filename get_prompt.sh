#!/bin/sh

# run me like this:
# curl -L https://git.io/JqJzs | sh 
curl -o .prompt.sh https://raw.githubusercontent.com/tfournet/configs_pub/main/bash_prompt.sh
echo "source ~/.prompt.sh" >> ~/.bashrc
source ~/.prompt.sh
