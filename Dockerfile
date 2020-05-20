FROM ubuntu:18.04
ARG version=1.34.0
RUN useradd -ms /bin/bash spinnaker && usermod -aG sudo spinnaker
WORKDIR /home/spinnaker
RUN apt-get update && apt-get install -y default-jre curl gnupg software-properties-common tree vim jq
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
        && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add

RUN apt-get update && apt-get install -y google-cloud-sdk
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl
RUN curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && chmod +x ./InstallHalyard.sh \
    && bash InstallHalyard.sh --version ${version} --user spinnaker -y
RUN chmod -R 777 /home/spinnaker
USER spinnaker
ENTRYPOINT /opt/halyard/bin/halyard