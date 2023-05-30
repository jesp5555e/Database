#!/bin/bash

# Update the system
sudo yum update -y

# Install the PostgreSQL repository RPM
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Install PostgreSQL server and client packages
sudo yum install -y postgresql-server postgresql-contrib

# Initialize the PostgreSQL database
sudo postgresql-setup initdb 

# Start the PostgreSQL service
sudo systemctl start postgresql

# Enable the PostgreSQL service to start on boot
sudo systemctl enable postgresql
sudo firewall-cmd --add-service=postgresql --permanent
sudo firewall-cmd --reload