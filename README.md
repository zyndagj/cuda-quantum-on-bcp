# cuda-quantum-on-bcp

Instructions for building an NVIDIA CUDA Quantum contaienr with Visual Studio Code to run on DGX Cloud.

Requirements:
- ngc cli
- make
- docker
- grep

## Installing and Configuring the NGC CLI

- [Installing the NGC Cli](https://docs.nvidia.com/base-command-platform/user-guide/index.html#installing-ngc-cli)
- [Create an NGC API key](https://docs.nvidia.com/base-command-platform/user-guide/index.html#generating-api-key)
- Log into NGC with Docker
```
      $ docker login nvcr.io
          Username: $oauthtoken
          Password: < Insert API key here >
```
- [Configure NGC CLI](https://docs.nvidia.com/base-command-platform/user-guide/index.html#configuring-ngc-cli-for-use)

> These steps only need to be done once

## Creating your workspace

```
make workspace
```

Creates a new worspace with the name `$(USER)_cuda_quantum_workspace`.
Please edit the makefile if you would prefer to use another workspace.

## Building the container

```
make container
make push
```

Creates a container based on [cuda-quantum:0.4.0](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda-quantum) and pushes it to your current ORG and TEAM registry.

## Running the container

```
# Submit a single GPU job
make run
```

By default, this starts a job on a single GPU instance.
The `NGPU` variable can be used to increase the number of GPUs allocated to the job (up to 8).

```
# Submit a 2 GPU job
make run NGPU=2
```

## Accessing VSCODE

Once the job is `RUNNING`, find the forwarded port URL in the job overview and open it.

![images/cudaq_job_overview.png]

Log in with the password `mypass`. This can be changed by editing the `PASSWORD=` variable in the Makefile.

![cudaq_login.png]

Once authenticated, you should see the typical VSCODE interface in your browser.

![cudaq_vscode.png]
