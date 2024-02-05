echo "Create the Project upload folder in /mnt Directory "
while folder= read -r line; do
        echo "$line"
mkdir -p /mnt/projectupload/$line/project
mkdir -p /mnt/projectupload/$line/inductiontrainings/idproofphotos
mkdir -p /mnt/projectupload/$line/inductiontrainings/photos
mkdir -p /mnt/projectupload/$line/inductiontrainings/signatures
mkdir -p /mnt/projectupload/$line/inductiontrainings/contractorworkorderphotos
mkdir -p /mnt/projectupload/$line/safetyactionable/photos
mkdir -p /mnt/projectupload/$line/safetyactionable/signatures
mkdir -p /mnt/projectupload/$line/safetyactionable/fingerprints
mkdir -p /mnt/projectupload/$line/incidentsReport/otherWitnessOfIncidentProfilePics
mkdir -p /mnt/projectupload/$line/incidentsReport/witnessesSignatures
mkdir -p /mnt/projectupload/$line/incidentsReport/incidentPhotos
mkdir -p /mnt/projectupload/$line/toolboxtraining/groupPhotos
mkdir -p /mnt/projectupload/$line/toolboxtraining/signatures
mkdir -p /mnt/projectupload/$line/workpermitssignatures
mkdir -p /mnt/projectupload/$line/workpermits/photos

done < project
