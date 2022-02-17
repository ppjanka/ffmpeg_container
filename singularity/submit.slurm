#!/bin/bash

#SBATCH -A snic2021-3-29      # allocation

#SBATCH -J ffmpeg-test        # job name
#SBATCH -t 00:10:00           # time requested

#SBATCH --nodes=1             # number of nodes
#SBATCH -p main               # partition

cd /cfs/klemming/projects/snic/snic2020-4-12/ppjanka/ffmpeg_container/singularity
srun -n 1 animate.sh -i test_data -o test.mp4 -n 256