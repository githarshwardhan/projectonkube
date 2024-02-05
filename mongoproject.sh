#!/bin/bash

# MongoDB Connection Information
HOST="localhost"
PORT="27017"
ADMIN_USER="admin"
ADMIN_PASSWORD="admin123"
appadminuser="safetyappadmin"
appadminpw="safetyapp#2020"
folderpath=$1

# Define an array of collections
collections=(
    '{"status":"Active","projectName":"Alixa Park","projectCode":"ALIXA_PARK","zoneName":"EAST ZONE","city":"Pune","contactNumber":"1234567890","address":"Pashan","numberofBuildings":2,"createdAt":ISODate("2021-12-16T09:23:07.075Z") }'
    '{"status":"Active","projectName":"Woods","projectCode":"WOODS","zoneName":"EAST ZONE","city":"Pune","contactNumber":"1234567890","address":"Pashan","numberofBuildings":2,"createdAt":ISODate("2021-12-16T09:23:07.075Z") }'
    '{"status":"Active","projectName":"Soteria","projectCode":"SOTERIA","zoneName":"EAST ZONE","city":"Pune","contactNumber":"1234567890","address":"Pashan","numberofBuildings":2,"createdAt":ISODate("2021-12-16T09:23:07.075Z") }'
)

# Define an array of database names and users
databases=(`cat /tmp/revamp-autmoation/projectdb`)
users=(`cat /tmp/revamp-autmoation/projectuser`)
passwords=("safetyapp#2022" "safetyapp#2022" "safetyapp#2022")

# Create users and insert collections into respective databases using a for loop
for i in "${!databases[@]}"; do
    database="${databases[$i]}"
    user="${users[$i]}"
    password="${passwords[$i]}"
    collection="${collections[$i]}"

    # Create a user for the database
    mongosh --host $HOST --port $PORT -u $ADMIN_USER -p $ADMIN_PASSWORD --authenticationDatabase admin <<EOF
    use $database
    db.createUser({user: "$user", pwd: "$password", roles: ["readWrite"]})
EOF

    # Insert collection into the database using the newly created user
    mongosh --host $HOST --port $PORT -u $user -p $password --authenticationDatabase $database <<EOF
    use $database
    db.projects.insert($collection)
EOF
    mongoimport --host $HOST --port $PORT -u $user -p $password --db $database --collection configurations --file /opt/build/$folderpath/project/vsa-revamp-project/src/scripts/day0/configurationtypes.json

    mongoimport --host $HOST --port $PORT -u $user -p $password --db $database --collection configurationtypes --file /opt/build/$folderpath/project/vsa-revamp-project/src/scripts/day0/configurations.json
done

# Insert data into safetyappadmindb
mongosh --host $HOST --port $PORT -u $ADMIN_USER -p $ADMIN_PASSWORD <<EOF
use safetyappadmindb
db.createUser({user: "$appadminuser", pwd: "$appadminpw", roles: ["readWrite"]})
db.projects.insert([
    { "projectCode": "ALIXA_PARK", "projectName": "Alixa Park" },
    { "projectCode": "WOODS", "projectName": "Woods" },
    { "projectCode": "SOTERIA", "projectName": "Soteria" }
])
EOF
