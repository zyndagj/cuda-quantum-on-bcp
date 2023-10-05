# Make sure Bash shell is used
SHELL := /bin/bash

# Automatically detecting NGC ORG and TEAM
RE := '(?<=\()[^)]*(?=\))'
ORG := $(shell ngc config current --format_type csv | grep org | grep -oP $(RE))
TEAM := $(shell ngc config current --format_type csv | grep team | cut -f 2 -d ',')

# Container URL
CUDAQ_VER := 0.4.0
ifeq ($(TEAM),)
	# Handle users without teams
	CONTAINER=nvcr.io/$(ORG)/$(USER)_cudaq_vscode:$(CUDAQ_VER)
else
	CONTAINER=nvcr.io/$(ORG)/$(TEAM)/$(USER)_cudaq_vscode:$(CUDAQ_VER)
endif
# Set Number of GPUs to allocate on BCP
NGPU=1
# Instance type
#INST := dgx1v.32g.$(NGPU).norm
INST := dgxa100.80g.$(NGPU).norm

# Allow comments in targets
.ONESHELL:

workspace:
	# https://docs.nvidia.com/base-command-platform/user-guide/index.html#creating-workspace-using-cli
	ngc workspace create --name $(USER)_cuda_quantum_workspace

container:
	# https://docs.nvidia.com/base-command-platform/user-guide/index.html#vscode-building-container
	if [ "$(CUDAQ_VER)" = "latest" ]; then
		echo -e "Using the nightly release to build \n\n\t$(CONTAINER)\n";
		docker build --build-arg BASE_VERSION=$(CUDAQ_VER) \
			--build-arg BASE_CONTAINER=ghcr.io/nvidia/cuda-quantum \
			-t $(CONTAINER) . ;
	else
		echo -e "Using a stable NGC release to build \n\n\t$(CONTAINER)\n"
		docker build --build-arg BASE_VERSION=$(CUDAQ_VER) \
			-t $(CONTAINER) .
	fi

run:
	# https://docs.nvidia.com/base-command-platform/user-guide/index.html#vscode-starting-job
	ngc batch run --total-runtime 1D \
		-w $(USER)_cuda_quantum_workspace:/workspace:RW \
		-n cuda_quantum_vscode \
		-i $(CONTAINER) \
		-in $(INST) \
		--result /result \
		--port 8899 \
		-c 'PASSWORD=mypass code-server --auth password --bind-addr 0.0.0.0:8899 /workspace & sleep infinity'

push:
	echo "Pushing $(CONTAINER)"
	docker push $(CONTAINER)
