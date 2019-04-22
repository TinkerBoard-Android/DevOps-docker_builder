IMAGE = asus/builder
IMAGE_U16 = asus/builder_ubuntu16.04

builder: Dockerfile
	docker build -t $(IMAGE) .

ubuntu16: Dockerfile_Ubuntu16
	docker build -f Dockerfile_Ubuntu16 -t $(IMAGE_U16) .

all: builder

.PHONY: all
