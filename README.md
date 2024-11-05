# Development Container
Utilize a custom docker image for development. Essentially just a homebrew Execution Environment. It uses SSH, host networking, and the user 'ansible' to run playbooks from a  directory that is bind-mounted to the container

## Dependencies
- A folder 'ssh-keys' with the public/private key the ansible user will use
- A file 'vault.pass' with a vault password that the entrypoint will point to

## Scripts
- build-ansible.sh: Build a dev container with the tag 'latest'. Additional tags can be appended
- run-ansible.sh: Run the container with podman and a specified directory with playbooks. See script for example usage. Add this script to your PATH for easy usage
