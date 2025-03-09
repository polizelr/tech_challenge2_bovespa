#!/bin/bash
sudo apt update -y
sudo apt install -y python3 python3-pip 

sudo apt install python3-venv -y
python3 -m venv tc2_bovespa
source tc2_bovespa/bin/activate

pip install pandas bs4 requests selenium webdriver-manager pyarrow 
