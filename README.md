# DEVPRO
In this repo I am working on a complete Development of a CI/CD Pipeline by building and automating an infrastructure using Terraform along with Deploying and automating a Node.js app into a Docker Image and pushing it into AWS ECR Repository, then pulling an image into AWS EC2 Instance and running the container.

# Steps Involved
- Create or Push Code into the Node.js app
- Create or Push Code in Terraform
- That will trigger the First Job of GitHub Actions to Create or Update Infrastructure
- Secondly it will trigger the Second Job of GitHub Actions to Create an image of the DockerFile and pushing into ECR Repository
- It will do an SSH to the Created AWS EC2 Instance and Pull the image from ECR Repository
- It will remove or replace the previous image or Container running in the instance.
- It will Run the Container of that Image. 