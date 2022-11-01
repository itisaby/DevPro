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

# Technologies Used

<div align="center">  
<a href="https://nodejs.org/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/nodejs-original-wordmark.svg" alt="Node.js" height="50" /></a>  
<a href="https://www.terraform.io/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/terraformio-icon.svg" alt="Terraform" height="50" /></a>  
<a href="https://aws.amazon.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/amazonwebservices-original-wordmark.svg" alt="AWS" height="50" /></a>  
<a href="https://github.com/" target="_blank"><img style="margin: 10px" src="https://profilinator.rishav.dev/skills-assets/git-scm-icon.svg" alt="Git" height="50" /></a>  
</div>