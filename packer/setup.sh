#!/bin/bash -xv

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get install -y openjdk-8-jre-headless

echo 'deb http://www.apache.org/dist/cassandra/debian 39x main' | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list
curl https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo apt-key adv --keyserver pool.sks-keyservers.net --recv-key A278B781FE4B2BDA
sudo apt-get -y update
sudo apt-get install -y cassandra
sudo service cassandra stop
sudo systemctl disable cassandra
sudo rm -rf /var/lib/cassandra/data/system/*
sudo rm -rf /var/lib/cassandra/*

sudo cp /tmp/jolokia-jvm-1.3.5-agent.jar /usr/share/java/
sudo cp /tmp/cassandra-default /etc/default/cassandra

sudo apt-get install -y python-mock python-configobj dh-python cdbs
sudo dpkg -i /tmp/diamond_4.0.519_all.deb

sudo dpkg -i /tmp/telegraf_1.1.2_amd64.deb
