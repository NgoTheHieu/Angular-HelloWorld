# LAB02: (Docker)

 

# -        Tạo một Docker image có tính năng khi start lên sẽ tự checkout Ansible / Terraform ở LAB01 về và thực hiện việc deploy

# -        Tạo 1 file Dockerfile build 1 Angular app Hello World (vd: https://github.com/DanWahlin/Angular-HelloWorld) và một Nginx server dùng để run app đó, đóng gói thành 1 image

# -        Deploy image đó trên VM bằng tay cũng như deploy bằng Ansible (optional: Deploy bằng Docker Compose)

# outline: node 16, clone git hello world ve, trong helloworld do chen cai workdir

# Stage 1 Compile and Build angular codebase
FROM node:16 as build


# Add the source code to app

RUN ["git", "clone", "https://github.com/DanWahlin/Angular-HelloWorld"]

WORKDIR /Angular-HelloWorld

# Install all the dependencies

RUN npm install && npm run build


# # Stage 2: Serve app with nginx server

# # Use official nginx image as the base image
# nginx state for serving content

FROM nginx:1.17.10-alpine

# Set working directory to nginx asset directory
EXPOSE 80

COPY --from=build Angular-HelloWorld/dist /usr/share/nginx/html


# Containers run nginx with global directives and daemon off

FROM jenkins/jenkins:2.319.2-jdk11
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.2 docker-workflow:1.27"
