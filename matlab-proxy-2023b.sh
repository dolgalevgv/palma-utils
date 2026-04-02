#!/bin/bash

#SBATCH --partition=normal
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=10:00:00
#SBATCH --job-name=matlab23b
#SBATCH --output=out/%x_%j.out


ml palma/2023b GCC/13.2.0 Python/3.11.5 Xvfb/21.1.9 matlab/R2023b


local_port="${1:-8888}"

CYAN="\033[0;36m"
COLOR_OFF="\033[0m"

MATLABPORT=$(shuf -i 8000-8500 -n 1)
TUNNELPORT=$(shuf -i 8501-9000 -n 1)
TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 49 | head -n 1)

echo -e "\nMATLAB Proxy\n"
echo -e "${CYAN}ssh -L ${local_port}:localhost:${TUNNELPORT} palma \"ssh -L ${TUNNELPORT}:localhost:${MATLABPORT} ${SLURMD_NODENAME} -N -4\"${COLOR_OFF}\n"
echo -e "${CYAN}http://localhost:${local_port}?mwi-auth-token=${TOKEN}${COLOR_OFF}\n"

MWI_APP_PORT="${MATLABPORT}" MWI_USE_EXISTING_LICENSE='True' MWI_ENABLE_TOKEN_AUTH='True' MWI_AUTH_TOKEN="${TOKEN}" matlab-proxy-app
