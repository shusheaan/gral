### dev ready

- pod torch 280 + ubuntu 24 + cuda 1281, template
- manual config process:
    - create pod, ssh over exposed tcp copied into vscode remote-ssh
    - $/home/root$ git clone gral and then $./env.sh$ and zsh in then $./install.sh$
- dockerfile:
    - check builder with $docker buildx ls$
    - create cloud builder ins: $docker buildx create --driver cloud shuswg/pod$
    - build: $docker buildx build --builder cloud-shuswg-pod --platform linux/amd64 -t shuswg/pod:latest --push ./pod$
    - create template in runpod pointing to $shuswg/pod:latest$
    - check storage $docker buildx du --builder cloud-shuswg-pod$ 
    - clear cloud cache $docker buildx prune --builder cloud-shuswg-pod --all --force$
    - lf req ubuntu lts 24+
    - **TODO**: build torch/cuda stack directly from ubuntu 24 instead of using pod images
    - **TODO**: personal setup scripts and dotfiles COPY