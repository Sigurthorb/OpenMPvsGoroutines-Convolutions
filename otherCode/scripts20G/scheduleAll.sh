#!/bin/bash

cd /lustre/cmsc714-1nzb/final/

sbatch repo/otherCode/scripts20G/lady.sh
sbatch repo/otherCode/scripts20G/lioness.sh
sbatch repo/otherCode/scripts20G/waterfall.sh
sbatch repo/otherCode/scripts20G/house.sh
#sbatch repo/otherCode/scripts20G/space.sh

