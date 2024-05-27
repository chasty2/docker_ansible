FROM docker.io/alpine:3.20.0

ENV ANSIBLE_VERSION=9.6.0
ENV ANSIBLE_LINT_VERSION=24.5.0

# Install dependencies
RUN apk update \
  && apk add --no-cache --progress python3 openssl \
  ca-certificates git openssh sshpass \
  && apk --update add --virtual build-dependencies \
  python3-dev py3-pip libffi-dev openssl-dev build-base bash \
  && rm -rf /var/cache/apk/* 

# Create ansible user and SSH key directory
RUN addgroup -S ansible && adduser -S ansible -G ansible \
  && mkdir -p /home/ansible/.ssh && chown ansible:ansible /home/ansible/.ssh \
  && chmod 0700 /home/ansible/.ssh

# I have commented this next part out, as this Dockerfile is intended to build
# a template image. This template is designed to be used with multiple ansible
# instances using different SSH keys. These lines should be run AS ROOT in 
# downstream Dockerfiles

# Copy SSH keys to ansible .ssh directory
#COPY ./ssh-keys/ansible_rsa /home/ansible/.ssh/id_rsa
#COPY ./ssh-keys/ansible_rsa.pub /home/ansible/.ssh/id_rsa.pub

# Set SSH key permissions
#RUN chown ansible:ansible /home/ansible/.ssh/id_rsa* \
#  && chmod 600 /home/ansible/.ssh/id_rsa \
#  && chmod 644 /home/ansible/.ssh/id_rsa.pub

# Switch to ansible user
USER ansible

# Add ansible users local/bin to PATH
ENV PATH="$PATH:/home/ansible/.local/bin"

# Upgrade pip3 and install ansible
RUN pip3 install --upgrade pip \
  && pip3 install ansible==${ANSIBLE_VERSION} --break-system-packages\
  && pip3 install ansible-lint==${ANSIBLE_LINT_VERSION} --break-system-packages

# Set ansible environment variables
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_RETRY_FILES_ENABLED false

# Switch back to root user
USER root

# Set 'entrypoint.sh' as the default entrypoint. I have also commented this out, to be set downstream
#COPY ./entrypoint.sh /entrypoint.sh
#ENTRYPOINT["bash","/entrypoint.sh"]
