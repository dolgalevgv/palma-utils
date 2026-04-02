#!/bin/bash

PORT="${1:-8010}"

echo 'Remote HTTP'
echo '-----------'
echo -e "ssh -L ${PORT}:localhost:${PORT} palma -N -4\n"
echo -e "http://localhost:${PORT}"

python -m http.server "${PORT}"
