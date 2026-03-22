### dev ready

- pod torch 280 + ubuntu 24 + cuda 1281, template
- manual config process:
    - create pod, ssh over exposed tcp copied into vscode remote-ssh
    - $/home/root$ git clone gral and then $./dependencies_pod.sh$ and zsh in then $./install_pod.sh$
    - TODO: bake dotfiles into docker copy and build dockerfile