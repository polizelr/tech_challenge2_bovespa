#!/bin/bash
sudo apt update -y
sudo apt install -y python3 python3-pip 

sudo apt install python3-venv -y
python3 -m venv tc2_bovespa
source tc2_bovespa/bin/activate

sudo apt update && sudo apt upgrade -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f

pip install pandas bs4 requests selenium webdriver-manager pyarrow

echo "EC2 criada com sucesso." > /home/ubuntu/logs.txt