#/bin/bash

#SBATCH --partition=normal
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=10:00:00
#SBATCH --job-name=jupyter
#SBATCH --output=out/%x_%j.out


module load palma/2023a
module load GCC/12.3.0 
module load Python/3.11.3
module load R/4.3.2
module load GSL/2.7
module load scikit-learn/1.3.1
module load matplotlib/3.7.2
module load Seaborn/0.13.2
module load JupyterLab/4.0.5


export R_LIBS_USER="${HOME}/R-4.3.2/library"
export JUPYTERLAB_SETTINGS_DIR="${HOME}/.jupyter/lab/user-settings/"
export JUPYTERLAB_WORKSPACES_DIR="${HOME}/.jupyter/lab/workspaces/"


CYAN="\033[0;36m"
COLOR_OFF="\033[0m"

LABPORT=$(shuf -i 8000-8500 -n 1)
TUNNELPORT=$(shuf -i 8501-9000 -n 1)
TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 49 | head -n 1)


echo -e "\nJupyterLab"
echo -e "----------\n"

echo "Forward ports with another terminal session on the local machine:"
echo -e "${CYAN}ssh -L 8888:localhost:${TUNNELPORT} palma \"ssh -L ${TUNNELPORT}:localhost:${LABPORT} ${SLURMD_NODENAME} -N -4\"${COLOR_OFF}\n"

echo "Link to connect using your browser:"
echo -e "${CYAN}http://localhost:8888/lab?token=${TOKEN}${COLOR_OFF}\n"

echo "To stop the job:"
echo -e "${CYAN}scancel ${SLURM_JOB_ID}${COLOR_OFF}\n"

jupyter lab \
    --no-browser \
    --ServerApp.root_dir=${HOME}/notebooks/ \
    --port=${LABPORT} \
    --ServerApp.token=${TOKEN} \
    --log-level WARN \
    --ServerApp.kernel_manager_class=jupyter_server.services.kernels.kernelmanager.AsyncMappingKernelManager
