#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y python3 python3-pip 
sudo apt install -y cron

# adiciona uma linha ao crontab para executar o script de segunda a sexta as 18h
(sudo crontab -l 2>/dev/null; echo "00 21 * * 1-5 . /tc2_bovespa/bin/activate && python3 /home/ubuntu/scraping.py >> /home/ubuntu/cron.log 2>&1 && deactivate") | sudo crontab -

chmod +x scraping.py

sudo apt install python3-venv -y
python3 -m venv tc2_bovespa
source tc2_bovespa/bin/activate

sudo apt update && sudo apt upgrade -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install -f

pip install pandas bs4 requests selenium webdriver-manager pyarrow

chmod +x scraping.py

deactivate

echo "EC2 criada com sucesso" > /home/ubuntu/ec2.logs