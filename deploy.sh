#!/bin/bash

# Define your variables
EC2_USER="your-ec2-username"
EC2_HOST="your-ec2-hostname"
EC2_KEY="${{ secrets.EC2_KEY }}"
REMOTE_DIR="path-on-ec2"

# Transfer files to EC2 instance
scp -i $EC2_KEY -r ./* ${EC2_USER}@${EC2_HOST}:${REMOTE_DIR}

# SSH into EC2 instance and restart application
ssh -i $EC2_KEY ${EC2_USER}@${EC2_HOST} << 'EOF'
  cd ${REMOTE_DIR}
  # Add commands to build and start your application
  ./restart-your-app.sh
EOF
