#!/bin/bash

cd /lustre/cmsc714-1nzb/final/

sbatch repo/otherCode/scripts20C/lady.sh
sbatch repo/otherCode/scripts20C/lioness.sh
sbatch repo/otherCode/scripts20C/waterfall.sh
sbatch repo/otherCode/scripts20C/house.sh
#sbatch repo/otherCode/scripts20C/space.sh

