IMAGE = asus/builder

builder: Dockerfile
	docker build -t $(IMAGE) .

all: builder

.PHONY: all
