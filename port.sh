#!/bin/bash

# Define the paths to the files containing port numbers and project names
port_file="/tmp/revamp-autmoation/port"
project_file="/tmp/revamp-autmoation/project"
service_port_file="/tmp/revamp-autmoation/serviceport"

# Read the port numbers and project names into arrays
readarray -t ports < "$port_file"
readarray -t projects < "$project_file"
readarray -t serviceports < "$service_port_file"

# Define the source and target port numbers
source_port=3031
service_source_port=30000

# Loop through the project names and port numbers to perform the replacements
for ((i=0; i<${#projects[@]}; i++)); do
  project_name="${projects[$i]}"
  port_number="${ports[$i]}"
  service_port_number="${serviceports[$i]}"
  
  # Define the path to the project and service YAML files
  project_yaml="/opt/deploy/${project_name}-deployment/project.yml"
  service_yaml="/opt/deploy/${project_name}-deployment/service.yml"
  project_env="/opt/deploy/${project_name}-deployment/.projectenv"

  # Check if the project YAML file exists
  if [ -e "$project_yaml" ]; then
    # Perform the replacement in the project YAML file using sed
    sed -i "s/$source_port/$port_number/g" "$project_yaml"
    echo "Replaced $source_port with $port_number in $project_yaml"
  else
    echo "Project YAML file not found: $project_yaml"
  fi

  # Check if the service YAML file exists
  if [ -e "$service_yaml" ]; then
    # Perform the replacement in the service YAML file using sed
    sed -i "s/$source_port/$port_number/g" "$service_yaml"
    sed -i "s/$service_source_port/$service_port_number/g" "$service_yaml"
    echo "Replaced $source_port with $port_number in $service_yaml"
    echo "Replaced $service_source_port with $service_port_number in $service_yaml"

  else
    echo "Service YAML file not found: $service_yaml"
  fi
 
 # Check if the service YAML file exists
  if [ -e "$project_env" ]; then
    # Perform the replacement in the service YAML file using sed
    sed -i "s/$source_port/$port_number/g" "$project_env"
    echo "Replaced $source_port with $port_number in $project_env"
  else
    echo "Service YAML file not found: $project_env"
  fi
done


