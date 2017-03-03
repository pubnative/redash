#!/usr/bin/env bash


cd /opt/redash/current
cp /opt/redash/.env /opt/redash/current
bower install



#install requirements
sudo pip install -r /opt/redash/current/requirements_dev.txt
sudo pip install -r /opt/redash/current/requirements.txt

# in production use requirements_all_ds.txt instead
sudo apt-get install libsasl2-dev
sudo pip install sasl
sudo pip install thrift
sudo pip install thrift_sasl
sudo pip install pyhive


#update database
bin/run ./manage.py database drop_tables
bin/run ./manage.py database create_tables
bin/run ./manage.py users create --admin --password admin "Admin" "admin"

#Purge Redis cache
redis-cli -n 1 FLUSHALL
