#!/bin/bash

CYAN="\033[0;36m"
COLOR_OFF="\033[0m"

LABPORT=$(shuf -i 8000-8500 -n 1)
TUNNELPORT=$(shuf -i 8501-9000 -n 1)
TOKEN=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 49 | head -n 1)

echo -e "${CYAN}ssh -L 8888:localhost:${TUNNELPORT} palma \"ssh -L ${TUNNELPORT}:localhost:${LABPORT} ${SLURMD_NODENAME} -N -4\"${COLOR_OFF}\n"

echo -e "${CYAN}http://localhost:8888/lab?token=${TOKEN}${COLOR_OFF}\n"

jupyter-lab --no-browser --port=${LABPORT} --ServerApp.token=${TOKEN}
