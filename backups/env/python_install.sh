# python
# anaconda
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
curl https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh --output anaconda.sh
sha256sum anaconda.sh; bash anaconda.sh # /home/shu/anaconda
rm anaconda.sh # (base) environment shown, check conda list

# conda package management
conda update conda
conda update anaconda

# gurobipy
conda config --add channels http://conda.anaconda.org/gurobi
conda install gurobi

# pip installs
pip install --upgrade pip
easy_install trash-cli # easier cli trash tool from ranger
pip install tensorflow-gpu torch torchvision cvxpy hydra-core optuna pytorch-lightning ipdb jupyter_contrib_nbextensions librosa numba
# check python dependencies by running python ./env/python.py

# julia
# R
