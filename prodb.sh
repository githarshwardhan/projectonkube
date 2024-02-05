#!/bin/bash
folderpath=$1

while db= read -r line; do
        echo "$line"    

        mongosh $line-projectdb --eval "db.createUser({user:'projectadmin',pwd:'c2FmZXR5I3ZzYTIwMjMh',roles:[{role:'dbOwner',db:'$line-projectdb'}]})"
       mongosh $line-projectdb --eval "db.getUsers()"

        echo "Inserting the Day 0 scripts"  
  mongoimport --db $line-projectdb --host localhost --port 27017 --username projectadmin --password c2FmZXR5I3ZzYTIwMjMh --collection configurationtypes --type json --file /opt/build/$folderpath/project/vsa-revamp-project/src/scripts/day0/configurationtypes.json
  mongoimport --db $line-projectdb --host localhost --port 27017 --username projectadmin --password c2FmZXR5I3ZzYTIwMjMh --collection configurations --type json --file /opt/build/$folderpath/project/vsa-revamp-project/src/scripts/day0/configurations.json
done < projectdb

