# 🎉 Automated CI/CD Setup 🎉

Welcome to the **Automated CI/CD** project! This repository is designed to help you set up Continuous Integration and Continuous Deployment (CI/CD) using GitHub Actions, Jenkins, and EC2. Follow the steps below to get everything running smoothly. 🚀

## 🌟 Introduction

This project provides a fully automated CI/CD pipeline using GitHub Actions for CI and deployment scripts for CD to an EC2 instance. It ensures that your code is tested and deployed seamlessly.

## ✨ Features

- **Automated Builds** with GitHub Actions 🛠️
- **Continuous Deployment** to EC2 instances 🌐
- **Seamless Integration** with Jenkins 🤖
- **Customizable Workflows** to suit your project needs ⚙️

## 📋 Prerequisites

Before you begin, ensure you have met the following requirements:

- You have a GitHub account.
- You have Jenkins set up with a job configured.
- You have an EC2 instance with SSH access.
- You have the following secrets ready:
  - `JENKINS_TOKEN`: Your Jenkins API token.
  - `EC2_KEY`: Your EC2 private key.

## 🚀 Installation

1. **Clone the Repository**

    ```sh
    git clone https://github.com/TejasO72/Automated-Ci-Cd.git
    cd Automated-Ci-Cd
    ```

2. **Create CI Workflow File**

    Create the `.github/workflows/ci.yml` file:

    ```yaml
    name: CI

    on: [push, pull_request]

    jobs:
      build:
        runs-on: ubuntu-latest

        steps:
        - name: Checkout repository
          uses: actions/checkout@v2

        - name: Run Jenkins job
          run: |
            JENKINS_URL="http://your-jenkins-url"
            JENKINS_JOB="your-jenkins-job"
            JENKINS_USER="your-jenkins-username"
            JENKINS_TOKEN="${{ secrets.JENKINS_TOKEN }}"
            
            curl -X POST "${JENKINS_URL}/job/${JENKINS_JOB}/build" \
              --user "${JENKINS_USER}:${JENKINS_TOKEN}"
    ```

3. **Create Deployment Script**

    Create the `deploy.sh` file:

    ```sh
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
    ```

4. **Make `deploy.sh` Executable**

    ```sh
    chmod +x deploy.sh
    ```

5. **Create CD Workflow File**

    Create the `.github/workflows/cd.yml` file:

    ```yaml
    name: CD

    on:
      push:
        branches:
          - main

    jobs:
      deploy:
        runs-on: ubuntu-latest

        steps:
        - name: Checkout repository
          uses: actions/checkout@v2

        - name: Deploy to EC2
          run: ./deploy.sh

        env:
          EC2_KEY: ${{ secrets.EC2_KEY }}
    ```

6. **Add Secrets to GitHub**

    - Navigate to `Settings` > `Secrets and variables` > `Actions`.
    - Click `New repository secret`.
    - Add `JENKINS_TOKEN` and `EC2_KEY`.

## 🛠️ Usage

- Push any changes to the `main` branch to trigger the CI/CD workflows.
- Check the status of the workflows in the `Actions` tab of your repository.

## ⚙️ Configuration

### Jenkins Configuration

- Set up Jenkins to use the provided API token.
- Ensure the Jenkins job URL is correctly specified in the CI workflow file.

### EC2 Configuration

- Ensure your EC2 instance is running and accessible via SSH.
- Update the `deploy.sh` script with the correct EC2 user, host, and path.


Made with ❤️ by [Tejas Tabrej]
