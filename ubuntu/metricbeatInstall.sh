#! /bin/bash

#Installing Metricbeats
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update && sudo apt-get install metricbeat
sudo update-rc.d metricbeat defaults 95 10
#Replace metricbeat yaml file
sudo rm -rf /etc/metricbeat/metricbeat.yml
sudo cp metricbeat.yml /etc/metricbeat
sudo cp ../es_certs/ /etc/metricbeat/ -r
#Enable modules
sudo cp ./modules.d/* /etc/metricbeat/modules.d/ -r
sudo metricbeat modules enable elasticsearch
sudo metricbeat modules enable system
sudo metricbeat modules enable kibana

#Test output connection and config
sudo metricbeat test output
sudo metricbeat test config
#Setup kibana dashboards
metricbeat setup -e
#Start Metricbeat
systemctl enable metricbeat
systemctl start metricbeat
