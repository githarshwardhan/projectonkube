#!/bin/bash 
################################################################
                           # BUILD IMAGE USING SRCS#
################################################################
folderpath=$1
########################## ERROR TRAP ##########################
function error_trap()
{
       if [ "$?" -ne "0" ]
       then
               echo "Error !!! \"$0\" Script Failed at \"$BASH_COMMAND\" command "
       else
               echo "Success !!! \"$0\" Script executed successfully in \"$SECONDS\" seconds"
       fi

}

trap error_trap EXIT
set -e
###############################################################
echo "We are doing day 0 DB activity"
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection entitlements --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/entitlements.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection roles --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/roles.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection categories --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/categories.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection statuses --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/statuses.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection rootcauses --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/rootcauses.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection emailconfigurations --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/emailconfigurations.json
mongoimport --db safetyappadmindb --host localhost --port 27017 --username safetyappadmin --password safetyapp#2020 --collection notifications --type json --file /opt/build/$folderpath/admin/vsa-revamp-admin/src/scripts/day0/notifications.json
##############################################################
echo *****Insert the App User in DB *****
mongosh safetyappadmindb --eval 'db.users.insert({
   "firstName":"Admin",
   "lastName":"User",
   "username":"admin",
   "email":"support@vastsafetyapp.com",
   "phoneNumber":"9988776655",
   "isAdmin":true,
   "isActive":true,
   "password":"$2b$10$N/WLUzfhQbVe11hoU/4mNO1YyqSXXnKUEGRDAHiNVGQll1VS5JXXC",
   "idProofType":"Pan Card",
   "idProofNumber":"FS23BD75676",
   "type":"Internal"
});
'
