#!/bin/bash
aa="sqld4rduaaz2x23a"
bb="localadmin"
cc="P@ssw0rd0101#"

# 1 install dotnet core
echo "-------------------------------------------------------- " >> /tmp/install.log
echo "1 install dotnet core" >> /tmp/install.log
sudo wget https://raw.githubusercontent.com/rodrigosantosms/aahc/master/2-poc/2-1-maintrack/templates/vmscaleset/dotnet-install.sh /tmp/  >> /tmp/install.log
cd /tmp
sudo ./dotnet-install.sh --channel LTS  >> /tmp/install.log


# 2 download application
sudo wget https://raw.github.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/music-app/music-store-azure-demo-pub.tar /
sudo mkdir /opt/music
sudo tar -xf music-store-azure-demo-pub.tar -C /opt/music
echo "2 download application" >> /tmp/install.log

# 3 install nginx, update config file
sudo apt-get install -y nginx
sudo service nginx start
sudo touch /etc/nginx/sites-available/default
sudo wget https://raw.githubusercontent.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/music-app/nginx-config/default -O /etc/nginx/sites-available/default
sudo cp /opt/music/nginx-config/default /etc/nginx/sites-available/
sudo nginx -s reload
echo "3 install nginx, update config file" >> /tmp/install.log

# 4 update and secure music config file
sed -i "s/<replaceserver>/$aa/g" /opt/music/config.json
sed -i "s/<replaceuser>/$bb/g" /opt/music/config.json
sed -i "s/<replacepass>/$cc/g" /opt/music/config.json
sudo chown $bb /opt/music/config.json
sudo chmod 0400 /opt/music/config.json
echo "4 update and secure music config file" >> /tmp/install.log

# 5 config supervisor
sudo apt-get install -y supervisor
sudo touch /etc/supervisor/conf.d/music.conf
sudo wget https://raw.githubusercontent.com/Microsoft/dotnet-core-sample-templates/master/dotnet-core-music-linux/music-app/supervisor/music.conf -O /etc/supervisor/conf.d/music.conf
sudo service supervisor stop
sudo service supervisor start
echo "5 config supervisor" >> /tmp/install.log

# 6 pre-create music store database
/usr/bin/dotnet /opt/music/MusicStore.dll &
echo "6 pre-create music store database" >> /tmp/install.log