FROM ubuntu
RUN sudo apt-get update
RUN sudo apt-get install -y nginx
CMD ["echo", "Image created"]
