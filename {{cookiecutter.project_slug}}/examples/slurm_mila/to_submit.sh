#!/bin/bash
#SBATCH --partition=long
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
#SBATCH --mem=5G
#SBATCH --time=0:05:00
#SBATCH --job-name={{ cookiecutter.project_slug }}
#SBATCH --output=logs/%x__%j.out
#SBATCH --error=logs/%x__%j.err
# to attach a tag to your run (e.g., used to track the GPU time)
# uncomment the following line and add replace `my_tag` with the proper tag:
##SBATCH --wckey=my_tag
# remove one # if you prefer receiving emails
##SBATCH --mail-type=all
##SBATCH --mail-user={{ cookiecutter.email }}

export MLFLOW_TRACKING_URI='mlruns'


# We try to be cluster friendly:
# we copy the data on the node local file system, run the exp, then copy the output back
DATA="../data"
OUTPUT="./output"

echo "original data folder: $DATA"
echo "output folder: $OUTPUT"

rsync -avzq $DATA $SLURM_TMPDIR
main --data ${SLURM_TMPDIR}/data --output ${SLURM_TMPDIR}/output --config config.yaml --disable-progressbar
rsync -avzq ${SLURM_TMPDIR}/output $OUTPUT
