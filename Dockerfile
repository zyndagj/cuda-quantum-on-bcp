ARG BASE_VERSION=0.4.0
ARG BASE_CONTAINER=nvcr.io/nvidia/cuda-quantum
FROM ${BASE_CONTAINER}:${BASE_VERSION}
ARG NSIGHT

# Must be root for mounts to work on BCP
USER root

# Install VS Code Server
# Latest release as of 8-11-23: v4.16.1
ARG CSVER=4.16.1
RUN wget https://github.com/coder/code-server/releases/download/v${CSVER}/code-server_${CSVER}_amd64.deb \
	&& dpkg -i ./code-server_${CSVER}_amd64.deb \
	&& rm -f code-server_${CSVER}_amd64.deb

# Install python extension
RUN code-server --install-extension ms-python.python

# Latest release as of 8-11-23: v1.17.5
ARG CPVER=1.17.5
RUN wget https://github.com/microsoft/vscode-cpptools/releases/download/v${CPVER}/cpptools-linux.vsix \
	&& code-server --install-extension cpptools-linux.vsix \
	&& rm -f cpptools-linux.vsix

# Install NSIGHT
#COPY NVIDIA.nsight-vscode-edition-2023.2.32964508.vsix NVIDIA.nsight-vscode-edition.vsix
#RUN code-server --install-extension NVIDIA.nsight-vscode-edition.vsix && \
#	rm -f NVIDIA.nsight-vscode-edition.vsix
