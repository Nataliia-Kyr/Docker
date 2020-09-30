FROM openshift/jenkins-slave-base-centos7:v3.11
WORKDIR /home/tfenv_installdir/tfenv-1.0.2/
RUN yum update -y && yum install -y java-11-openjdk-devel
ENV KUBE_LATEST_VERSION="v1.19.1" \
    HELM_VERSION="v3.3.1" \
	HADOLINT_VERSION="v1.18.0" \
	HELM_PUSH_PLUGIN_VERSION="v0.8.1"
ARG TFENV_VERSION=1.0.2  
ARG TGENV_VERSION=0.0.3 
ARG TERRAFORM_VERSION=0.11.3

#SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
	&& mv /usr/local/bin/kubectl /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm \
    && chmod g+rwx /root \
    && mkdir /config \
    && chmod g+rwx /config
RUN helm plugin install https://github.com/chartmuseum/helm-push.git --version ${HELM_PUSH_PLUGIN_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -O /home/hadolint https://github.com/hadolint/hadolint/releases/download/${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
    && export PATH=/home:$PATH \
    && chmod +x /home/hadolint

WORKDIR /home/tfenv_installdir
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN mkdir -p /opt/tfenv/1.0.2/ && \
    wget "https://github.com/tfutils/tfenv/archive/v1.0.2.tar.gz" && \
    tar xf v1.0.2.tar.gz
WORKDIR /home/tfenv_installdir/tfenv-1.0.2/
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN cp -R bin libexec share /opt/tfenv/1.0.2/ && \
    ln -s /opt/tfenv/1.0.2/bin/terraform /usr/local/bin/terraform && \
    ln -s /opt/tfenv/1.0.2/bin/tfenv /usr/local/bin/tfenv && \
    tfenv install 0.11.3 && \
    rm -Rf /home/tfenv_installdir
