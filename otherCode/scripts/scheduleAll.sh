#!/bin/bash

cd /lustre/cmsc714-1nzb/final/repo

module load gcc
module load go

make all

chmod +x otherCode/scripts/*.sh

sbatch otherCode/scripts/spaceC.sh
sbatch otherCode/scripts/spaceG.sh

#sbatch otherCode/scripts/houseC.sh
sbatch otherCode/scripts/houseG.sh

#sbatch otherCode/scripts/lionessC.sh
sbatch otherCode/scripts/lionessG.sh

#sbatch otherCode/scripts/waterfallC.sh
sbatch otherCode/scripts/waterfallG.sh

#sbatch otherCode/scripts/ladyC.sh
sbatch otherCode/scripts/ladyG.sh


