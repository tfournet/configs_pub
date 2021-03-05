#!/bin/sh

# My URL is 
curl -o .prompt.sh https://raw.githubusercontent.com/tfournet/configs_pub/main/bash_prompt.sh
echo "source ~/.prompt.sh" >> ~/.bashrc
