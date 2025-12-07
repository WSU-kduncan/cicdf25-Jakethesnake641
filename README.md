# CI/CD Dad Joke Central Deployment Repository
Jacob Wing, wing.10@wright.edu
- This repository contains all files for both the Continuous Integration and Continuous Deployment pipelines
 for the Dad Joke Central web application. The CI pipeline automatically builds and publishes Docker 
images to DockerHub, while the CD pipeline automatically updates the application on AWS EC2 instance 
when new images are pushed.
## Repository Contents
- web-content/
  - HTML/CSS files for Dad Joke Central website
- Dockerfile
  - Defines how the application is built
- deployment/
  - Contains deploy.sh, webhook hooks.json, and systemd service file for CD
- .github/workflows
  - GitHub Actions workflows for CI and CD
- README-CI.md
  - Documentation for Continuous integration
- README-CD.md
  - Documentation for Continuous Deployment
## README-CI.md - Continuous Integration
- Covers:
  - How Docker image is built
  - Semantic versioning tags
  - GitHub Actions workflow explanation
  - Pushing images to DockerHub
  - How to test CI pipeline
- Link: https://github.com/WSU-kduncan/cicdf25-Jakethesnake641/blob/main/README-CI.md
## README-CD.md - Continuous Deployment
- Covers: 
  - EC2 setup and Docker installation
  - Auto-refresh deployment script
  - Webhook config
  - systemd service for webhook listener
  - GitHub Action payload sender
  - Full CD workflow explanation and Diagram
- Link: https://github.com/WSU-kduncan/cicdf25-Jakethesnake641/blob/main/README-CD.md
