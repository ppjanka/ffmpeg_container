#!/usr/bin/env bash

# Use docker-ffmpeg to animate all png files from the folder given as argument

# Parse the arguments
nproc=1
while getopts ":n:i:o:" argname; do
    case $argname in
        n) nproc=$OPTARG;;
        i) input_dir=$OPTARG;;
        o) output_name=$OPTARG;;
        ?) echo Argument not recognized. Aborting.; exit;;
    esac
done
if [[ -z $input_dir || -z $output_name ]]; then
    echo "Please specify the input directory and output name (-i, -o). Aborting."
    exit
fi
# extend to absolute paths
input_dir=$(realpath $input_dir)
output_name=$(realpath $output_name)
# get the output directory for passthrough
output_dir=$(dirname "$output_name")
if [ "$output_dir" = '.' ]; then
    output_dir=$(pwd)
fi
echo $output_dir

# Process using ffmpeg
docker run --rm \
 -u $(id -u):$(id -g) \
 --mount src="$input_dir",target='/workdir/input',type=bind \
 --mount src="$output_dir",target='/workdir/output',type=bind \
 docker-ffmpeg /bin/bash \
  -c "cd /workdir && \
      ffmpeg -threads $nproc -y -r 20 -f image2 -i \"input/comparison_%*.png\" -f mp4 -q:v 0 -vcodec mpeg4 -r 20 output/$(basename $output_name)"